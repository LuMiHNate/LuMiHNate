//
//  FeedViewController.swift
//  HZ
//
//  Created by Matthew Soto on 5/18/21.
//

import UIKit
import SpotifyLogin

class FeedViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        //clear user information
        userSpotifyID = ""
        bearerAccessToken = ""
        defaults.setValue("", forKey: "userID")
        
        //logout user
        SpotifyLogin.shared.logout()
        
        //go back to login screen
        performSegue(withIdentifier: "logoutPressed", sender: self)
    }
    
    @IBAction func addPostPressed(_ sender: Any) {
        performSegue(withIdentifier: "addPostSegue", sender: self)
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
