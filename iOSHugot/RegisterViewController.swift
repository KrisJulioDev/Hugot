//
//  RegisterViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 8/8/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var email : UITextField!
    @IBOutlet weak var displayName : UITextField!
    
    @IBOutlet weak var password : UITextField!
    @IBOutlet weak var confirmPassword : UITextField!
    
    @IBOutlet weak var regBtn : UIButton!
    
    var isAgreed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isAgreed {
            
            register()
            
        }
    }
    

    @IBAction func register() {
        
        if password.text != confirmPassword.text {
            
            let alert = UIAlertController(title: "Registration failed", message: "Passwords didn't match", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                _ in
                
            })
            
            alert.addAction(ok)
            
            self.presentViewController(alert, animated: true, completion: nil)

            return
        }
        
        
        guard isAgreed else { return }
        
        SVProgressHUD.show()
        
        FIRAuth.auth()?.createUserWithEmail(email.text!, password: password.text!, completion: { [weak self]
            result, error in
            
            SVProgressHUD.dismiss()
            if let e = error {
                
                let alert = UIAlertController(title: "Registration failed", message: e.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                    _ in
                    
                })
                
                alert.addAction(ok)
                
                self?.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                debugPrint(result)
                
                // create user if still not saved to servera
                UserViewModel().saveNewUser()
                
                let ref = DataObserver.dataServiceInstance.UserRef
                
                let dict = ["name" : self?.displayName.text ?? "",
                            "email" : self?.email.text ?? "",
                            "dateCreated" : FIRServerValue.timestamp(),
                            "photoURL" : "",
                            "hearts" : 50]
                
                ref.updateChildValues(["\(FIRAuth.auth()!.currentUser!.uid)": dict])
                ViewHelper.showActivityStoryBoardFromVC(self!)
            }
            
            })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is TermsAndConditionsViewController {
            (segue.destinationViewController as! TermsAndConditionsViewController).delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
