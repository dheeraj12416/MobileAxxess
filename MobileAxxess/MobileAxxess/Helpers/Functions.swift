//
//  Functions.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class Functions: NSObject {
    
    //MARK: - MBProgressHUD
    
    func showHud()
    {
        appDelegate().hudCount += 1
        if appDelegate().hudCount <= 1
        {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: appDelegate().window!, animated: true)
            }
        }
    }
    
    func hideHud()
    {
        appDelegate().hudCount -= 1
        if appDelegate().hudCount <= 0
        {
            MBProgressHUD.hide(for: appDelegate().window!, animated: true)
        }
    }
    
    //MARK: - Internet Functions
    func connectionToInternetIsAvailable() -> Bool{
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    //MARK: - Alerts
    func showAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: GlobalConstants.Constants.appName, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                
            })
            alertController.addAction(okAction)
            appDelegate().window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
