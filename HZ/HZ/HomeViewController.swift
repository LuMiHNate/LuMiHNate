//
//  HomeViewController.swift
//  HZ
//
//  Created by Matthew Soto on 5/14/21.
//

import UIKit
import SpotifyLogin

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // this is just to test that logging out works
        // you can comment this out if you don't want to be logged out when you hit the profile screen
        SpotifyLogin.shared.logout()
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

