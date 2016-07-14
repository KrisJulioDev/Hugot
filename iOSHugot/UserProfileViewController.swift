//
//  UserProfileViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/6/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import Firebase

class UserProfileViewController: MainViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameButton : UIButton!
    @IBOutlet weak var heartsLabel : UILabel!
    @IBOutlet weak var userDisplayPhoto : UIImageView!
    @IBOutlet weak var progressLabel : UILabel!
    
    @IBOutlet weak var userPosted : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDisplayPhoto.layer.borderColor = UIColor.whiteColor().CGColor
        userDisplayPhoto.layer.borderWidth = 2
        userDisplayPhoto.clipsToBounds = true
        
        
        
        populateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Profile"
        
        let done = UIBarButtonItem(image: UIImage(named: "delete"), style: .Plain, target: self, action: #selector(UserProfileViewController.dismissVC))
        self.navigationItem.leftBarButtonItem = done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateData() {
        if let userData = SaveData.sharedInstance.userProfile {
            let name =  "@\(userData.displayName ?? "unknown")"
            let hearts = userData.userHearts
            let posts = userData.userPosts ?? 0
            let imageURL = userData.displayPhotoURL ?? ""
            
            self.usernameButton.setTitle(name.stringByReplacingOccurrencesOfString(" ", withString: ""), forState: .Normal)
            self.heartsLabel.text = "\(hearts)"
            self.userPosted.text = "\(posts)"
            
            
            self.userDisplayPhoto.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: nil, options: .ProgressiveDownload, progress: { rs, es in
                
                let progress = ( rs / es ) * 100
                self.progressLabel.text = "\(progress)%"
                
                }, completed: { image, data, error, finished in
                    
                    self.progressLabel.hidden = true
                    
            })
            
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //Nothing to login here
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        do {
            try FIRAuth.auth()?.signOut()
            self.trackLogout()
            
            UserHelper.removeIDForPushNotif()
            ViewHelper.showMainStoryBoardFromVC(self)
        }
        catch {
            
        }
        
    }
    func dismissVC() {
       self.dismissViewControllerAnimated(true, completion: nil)
    }

}
