//
//  HomeDataParser.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import UIKit

class HomeDataParser: NSObject {
    
    static let shareInstance = HomeDataParser()
    var homeViewArray : Array<HomeViewData>?

    func parseResponse(response:AnyObject!) -> Array<HomeViewData>?
    {
        if let response: NSArray = response as? NSArray
        {
            homeViewArray = Array<HomeViewData>()
            for (_, parentElement) in response.enumerated()
            {
                if let dict : Dictionary<String, Any> = parentElement as? Dictionary<String, Any>{
                    let data = HomeViewData()
                    data.id = dict["id"] as? String
                    data.type = dict["type"] as? String
                    data.date = dict["date"] as? String
                    data.text = dict["data"] as? String
                    data.imageData = nil
                    data.imageDownloaded = false
                    homeViewArray?.append(data)
                }
            }
        }
        return homeViewArray
    }
}
