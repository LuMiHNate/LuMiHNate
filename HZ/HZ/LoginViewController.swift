//
//  LoginViewController.swift
//  HZ
//
//  Created by Fate  on 4/28/21.
//


import UIKit
import SpotifyLogin
import NotificationCenter
import Parse

class LoginViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = defaults.string(forKey: "userID")
        print(userID ?? "nil")
        if userID != nil {
            userSpotifyID = userID!
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessful),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)
    }
    
    @objc func loginSuccessful() {
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                // User is not logged in, show log in flow.
            } else {
                let url = URL(string: "https://api.spotify.com/v1/me")!
                var request = URLRequest(url: url)
                request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                   // This will run when the network request returns
                   if let error = error {
                      print(error.localizedDescription)
                   } else if let data = data {
                    
                    let decoder = JSONDecoder()
                    do {
                        let currentUser = try decoder.decode(User.self, from: data)
                        
                        //checks to see if there are any users with this id in the database
                        let query = PFQuery(className:"Users")
                        query.whereKey("spotify_id", equalTo: currentUser.id)
                        query.countObjectsInBackground { (count: Int32, error: Error?) in
                            if let error = error {
                                // The request failed
                                print(error.localizedDescription)
                            } else {
                                
                                //if there aren't any users in the database with this id, add it
                                if count == 0 {
                                    let user = PFObject(className: "Users")
                                    user["spotify_id"] = currentUser.id
                                    user["country"] = currentUser.country
                                    user["display_name"] = currentUser.display_name
                                    if currentUser.images.count != 0 {
                                        user["image_url"] = currentUser.images[0].url
                                    }
                                    
                                    user.saveInBackground {
                                      (success: Bool, error: Error?) in
                                      if (success) {
                                        print("user was saved!")
                                      } else {
                                        print(error?.localizedDescription)
                                      }
                                    }
                                } else {
                                    print("user already exists!")
                                }
                                self.defaults.set(currentUser.id, forKey: "userID")
                                userSpotifyID = currentUser.id
                                let userID = self.defaults.string(forKey: "userID")
                                print(userID ?? "nil")
                                
                                
                            }
                        }
                        
                    } catch {
                        print("Couldn't decode the response")
                    }
                    
                   }
                }
                task.resume()
                
            }
        }
        
        performSegue(withIdentifier: "loginSuccessful", sender: self)
    }
    
    @IBAction func signIn(_ sender: Any) {
        SpotifyLoginPresenter.login(from: self, scopes: [.userReadPrivate, .userReadEmail, .userLibraryRead])
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
