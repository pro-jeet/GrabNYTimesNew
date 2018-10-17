//
//  HttpCommunication.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 17/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import Foundation


class HttpCommunication {
    
    static let sharedInstance = HttpCommunication()
    
    func httpCommunicationWithRequest(url:URLRequest,  complitionHandler:@escaping ((Any,Bool)->Void))
    {
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url as URLRequest) { (data, response, error) in
            guard error == nil && data != nil else {
                complitionHandler(error as Any,false)
                return
            }
            do {
                let responseString = try  JSONSerialization.jsonObject(with: (data)!, options: .allowFragments)
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200
                {
                    complitionHandler(responseString as Any,true)
                    return
                }
                DispatchQueue.main.async(execute: {
                    complitionHandler(responseString,true)
                })
            }catch let error as NSError
            {
                complitionHandler(error,false)
            }
            
        }
        task.resume()
    }
}
