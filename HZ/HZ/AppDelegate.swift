//
//  AppDelegate.swift
//  HZ
//
//  Created by Lanique Peterson
//

import UIKit
import Parse
import SpotifyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "6jWMG44YMJNu8g25tOffzStjoGDNW5B4IqIU7wMr"
            $0.clientKey = "OZYnZwvLJ1ItPxCF7tZctqoNc0cVhzR1TcY2litA"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        
        //spotify stuff
        SpotifyLogin.shared.configure(clientID: "23183cac7ace4cd284abfb29c8c484b5", clientSecret: "28f288c97a784a5db07df81b37a66b6a", redirectURL: URL(string: "wavelength-social-media://callback")!)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

