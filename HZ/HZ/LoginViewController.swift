//
//  LoginViewController.swift
//  HZ
//
//  Created by ピタソン・ラニク.
//

import UIKit
import SpotifyLogin
import NotificationCenter

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessful),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)
    }
    
    @objc func loginSuccessful() {
        performSegue(withIdentifier: "loginSuccessful", sender: self)
    }
    
    @IBAction func signIn(_ sender: Any) {
        SpotifyLoginPresenter.login(from: self, scopes: [.streaming, .userLibraryRead])
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
