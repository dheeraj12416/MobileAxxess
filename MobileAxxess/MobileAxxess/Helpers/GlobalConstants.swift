//
//  GlobalConstants.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import UIKit

public enum AlertPopupType: Int {
    case success = 1
    case error = 2
    case question = 3
}

public struct GlobalConstants {
    
    struct Constants {
        static let appName = "MobileAxxess"
    }
    
    struct Errors {
        static let internetConnectionError = "Internet connection not available."
        static let dataNotAvailable = "Data not available."
    }
    
    struct API {
        static let getHomeList = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"
    }
}
