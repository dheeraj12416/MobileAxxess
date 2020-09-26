//
//  APIHandler.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Nannapuraju, Dheeraj R. All rights reserved.
//

import UIKit

class APIHandler: NSObject {
    
    //MARK: Global Mthod For Handling API Calls
    private func sendRequestWithUrl(apiUrl : String, requestType : String, bodyParameters : NSDictionary?, completionHandler: @escaping (_ success : Bool, _ response : Any?, _ error : NSString?) ->())
    {
        //Check that there is an internet connection available before to send the request
        if Functions().connectionToInternetIsAvailable()
        {
            let url = URL.init(string: apiUrl)
            var requestUrl = URLRequest.init(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            requestUrl.httpMethod = requestType
            requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
            requestUrl.addValue("application/json", forHTTPHeaderField: "Accept")
            if (bodyParameters?.count)! > 0
            {
                do {
                    requestUrl.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters!, options: .prettyPrinted)
                } catch let catchError as NSError{
                    completionHandler(false, nil, catchError.localizedDescription as NSString?)
                }
            }
            let urlConfig = URLSessionConfiguration.default
            let session = URLSession.init(configuration: urlConfig)
            let task = session.dataTask(with: requestUrl, completionHandler: {
                (response, data, error) -> Void in
                if let strError = error?.localizedDescription {
                    
                    //Error has been enconter with the request return error message to the user
                    completionHandler(false, nil, strError as NSString?)
                } else {
                    do {
                        let responseDict = try JSONSerialization.jsonObject(with: response!, options: .mutableContainers)
                        completionHandler(true, responseDict, nil)
                    }
                    catch let catchError as NSError
                    {
                        completionHandler(false, nil, catchError.localizedDescription as NSString?)
                    }
                }
            })
            task.resume()
        }
        else
        {
            Functions().showAlertMessage(message: GlobalConstants.Errors.internetConnectionError)
        }
    }
    
        //MARK: - Get Home List
        func getHomeList(parameters: NSDictionary?, completionHandler: @escaping (_ success: Bool, _ response : Array<HomeViewData>?, _ error: String?) ->() ) {

            sendRequestWithUrl(apiUrl: GlobalConstants.API.getHomeList, requestType: "GET", bodyParameters: parameters) {
                (success, response, error) -> () in
    
                //Check if the API request have been successful
                if success {
    
                    //Request successful
                    //Check if the confirmation are available
                    if let confirmation = response {
    
                        //confirmation available return it to the user
                        completionHandler(true, HomeDataParser.shareInstance.parseResponse(response: confirmation as AnyObject), nil)
                    } else {
    
                        //confirmation not available return error to the user
                        completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
                    }
                } else {
    
                    //Request have enconter an error return error to the user
                    completionHandler(false, nil, error as String?)
                    Functions().showAlertMessage(message: error! as String)
                }
            }
        }
}
