//
//  SharedManager.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 17/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import Foundation
import UIKit
import Reachability

class SharedManager
{
    static let shared:SharedManager = SharedManager()
    
    // MARK:############## NSUSER DEFAULTS  ########################
    
    func saveToUserDefaults(value: Any, key: String)
    {
        let defs = UserDefaults.standard
        defs.set(value, forKey: key)
        defs.synchronize()
    }
    func getValueFromUserDefaults(for key: String) -> Any
    {
        return UserDefaults.standard.object(forKey: key) as Any
    }
    func removeObjectFromUserDefaults(key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK:############## UIALERT ACTIONS  ########################
    
    func displayAlertWithActions(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?])
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        topVC?.present(alert, animated: true, completion: nil)
    }
    func displaAlert(message: String, title: String)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        if self.checkIfAlertViewHasPresented() != nil {
            
        } else {
            topVC?.present(alertView, animated: true, completion: nil)
        }
    }
    func checkIfAlertViewHasPresented() -> UIAlertController? {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if topController is UIAlertController {
                return (topController as! UIAlertController)
            } else {
                return nil
            }
        }
        return nil
    }
    //MARK: Internet connectivity check method
    func isInternetConnectivityAvailable() -> Bool
    {
        // write code for internet connection
        if let reachable = Reachability(){
            if(reachable.connection == .none)
            {
                displaAlert(message:"ERROR !", title:  "⚠️ No Internet Connection")
                return false
            }
            else
            {
                return true
            }
        }
        return false
        
    }
    func isInternetConnectivityAvailableWithOutAlert() -> Bool
    {
        // write code for internet connection
        if let reachable = Reachability(){
            if(reachable.connection == .none)
            {
                return false
            }
            else
            {
                return true
            }
        }
        return false
        
    }
    
    // MARK:############## VALIDATE EMAIL,PHONE ETC  ########################
    
    func isValidEmail(validateEmail:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: validateEmail)
    }
    func isValidMobileNo(mobileNo:String)->Bool{
        
        let phoneRegEx = "^(?:(?:\\+|0{0,2})91(\\s*[\\ -]\\s*)?|[0]?)?[456789]\\d{9}|(\\d[ -]?){10}\\d$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: mobileNo)
    }
    
    
}

