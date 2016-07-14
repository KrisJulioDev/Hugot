//
//  ViewControllerExtensions.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/5/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
     
    static func instanceWithDefaultNib() -> Self {
        let className = NSStringFromClass(self as! AnyClass).componentsSeparatedByString(".").last
        let bundle = NSBundle(forClass: self as! AnyClass)
        return self.init(nibName: className, bundle: bundle)
    }
    
    static func showHud( label : String = "") {
        
        if label == "" {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.showWithStatus(label)
        }
        
        let maxSecondsToWait = Double(10)
        delay(maxSecondsToWait, closure: {
            self.hideHud()
        })
    }
    
    static func showSuccessHud() {
        SVProgressHUD.showWithStatus("Posted")

    }
    
    static func hideHud() {
        
        SVProgressHUD.dismiss()
    }
    
    static func keyWindow() -> UIWindow {
        return UIApplication.sharedApplication().keyWindow!
    }
}
