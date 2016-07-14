
//
//  ViewHelper.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit

class ViewHelper {
    
    static func showActivityStoryBoardFromVC( presenter : UIViewController ) {
        
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("activityNavigation") as! UINavigationController
        presenter.presentViewController(vc, animated: false, completion: nil)
        
    }
    
    static func showMainStoryBoardFromVC( presenter : UIViewController ) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("mainNavigation") as! UINavigationController
        presenter.view.window?.rootViewController = vc
    }
}
