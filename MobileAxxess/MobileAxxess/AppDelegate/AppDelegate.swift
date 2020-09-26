//
//  AppDelegate.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import UIKit

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hudCount = 0//To set count for displaying MBProgressHUD
    var cartCount = 0//To set count for displaying MBProgressHUD


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _ = CoreDatabase.sharedInstance()//Initialize Core Data
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController.init(nibName: "ViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: vc)
        window?.rootViewController = nav;
        window?.makeKeyAndVisible()
        return true
    }
}

