//
//  UIViewController+ActivityIndicator.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 17/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

// MARK:############## STORYBOARD RELATED  ########################

import UIKit
import Foundation
import NVActivityIndicatorView

extension UIViewController:NVActivityIndicatorViewable
{
    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T
    {
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: Bundle.main)// place bundle nil if not working
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    // MARK:############## ACTIVITY INDICATOR   ########################
    
    func showAnimatingIndicator()
    {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: NVActivityIndicatorType(rawValue: 32)!)
    }
    func stopAnimatingIndicator()
    {
        self.stopAnimating()
    }
    func showIndicatorWithMSG(msg:String)
    {
        let size = CGSize(width: 50, height: 50)
        // startAnimating(size, message: msg, type: NVActivityIndicatorType(rawValue: 32)!, fadeInAnimation: nil)
        startAnimating(size, message: msg, messageFont: UIFont(name: "Arial", size: 15.0), type: NVActivityIndicatorType(rawValue: 32)!, color: .white, textColor: .white)
        
    }
    
}

