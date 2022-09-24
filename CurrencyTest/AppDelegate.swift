//
//  AppDelegate.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        router.presentInitial()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}
