//
//  LoginViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton : FBSDKLoginButton!
    @IBOutlet weak var fakeLaunchScreen : UIView!
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        delay(1, closure: {
            self.fakeLaunchScreen.removeFromSuperview()
        })
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"];
        loginButton.publishPermissions = ["publish_actions"]
    } 
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let error = error {
            debugPrint("Facebook login failed \(error.description)")
        } else if result.isCancelled {
            debugPrint("Facebook login cancelled")
        } else {
            debugPrint("Facebook login successfully")
            self.loginButton.hidden = true
            SVProgressHUD.show()
            
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
            
            FIRAuth.auth()?.signInWithCredential(credential) { [weak self] ( user, error) in
                
                if let error = error {
                    debugPrint("Firebase login failed \(error.description)")
                } else {
                    
                    
                    self?.showActivityPage()
                    UserViewModel().saveNewUser()
                }
                
            }
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {}
    
    //MARK: Transition to Actiivty
    func showActivityPage() {
        
        ViewHelper.showActivityStoryBoardFromVC(self)
        
    }
    
}
