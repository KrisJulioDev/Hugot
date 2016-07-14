//
//  AppDelegate.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/1/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        FIRApp.configure()
        BatchConfigure()
        
        //transparent nav
        setupNavBar()
        
        if UserHelper.isAuthenticated {
            
            // create user if still not saved to server
            UserViewModel().saveNewUser()
            
            if let w = self.window, rvc = w.rootViewController {
                
                w.makeKeyAndVisible()
                ViewHelper.showActivityStoryBoardFromVC(rvc)
                 
                if let id = UserHelper.userId {
                    UserHelper.saveUniqueIDForPushNotif(id)
                }
                
            }
        }
         
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func BatchConfigure() {
        Batch.startWithAPIKey(BatchLIVEAPIKey)
        BatchPush.registerForRemoteNotifications()
    }
    
    func setupNavBar() {
        // Override point for customization after application launch.
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().translucent = true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        debugPrint("Token \(deviceToken)")
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        BatchPush.dismissNotifications()
    }
    
    func applicationWillResignActive(application: UIApplication) {     }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

