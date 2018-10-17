//
//  NetworkManeger.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 17/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    
    static let sharedInstance = NetworkManager()
    
    func sendUrlRequestToServer(url:String,parameters:NSDictionary?,taskType:Int,complitionHandler:@escaping ((Any,Bool)->Void))
    {
        guard let url = URL(string:url)
            else{
                print("url not formed")
                return
        }
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest.init(url: url)
        
        if(parameters != nil)
        {
            // let data = NSKeyedArchiver.archivedData(withRootObject: parameters as Any)
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters as Any, options: [])
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData;
        }
        
        HttpCommunication.sharedInstance.httpCommunicationWithRequest(url: urlRequest as URLRequest) { (response,success) in
            complitionHandler(response,success)
        }
    }
}
