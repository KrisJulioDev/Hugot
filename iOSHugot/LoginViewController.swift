//
//  LoginViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
 
    @IBOutlet weak var fakeLaunchScreen : UIView!
    @IBOutlet weak var email : UITextField!
    @IBOutlet weak var pass : UITextField!

    
    private let segueToTC = "terms_and_cond"
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        delay(1, closure: {
            self.fakeLaunchScreen.removeFromSuperview()
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func login() {
        
        SVProgressHUD.show()
        
        FIRAuth.auth()?.signInWithEmail(self.email.text ?? "", password: self.pass.text ?? "", completion: {
            result, error in
            
            SVProgressHUD.dismiss()
            if let e = error {
                
                let alert = UIAlertController(title: "Login failed", message: e.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                    _ in
                    
                })
                
                alert.addAction(ok)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                // create user if still not saved to servera
                UserViewModel().saveNewUser()
                ViewHelper.showActivityStoryBoardFromVC(self)
            }
            
        })
    
        delay(10, closure: {
            SVProgressHUD.dismiss()
        })
        
        
    }

    
    //MARK: Transition to Actiivty
    func showActivityPage() {
        
        ViewHelper.showActivityStoryBoardFromVC(self)
        
    }
    
    
}
