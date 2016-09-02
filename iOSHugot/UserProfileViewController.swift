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
import SVProgressHUD

class UserProfileViewController: MainViewController {

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
            
            self.usernameButton.rx_tap.subscribeNext({ [weak self] _ in
                
                self?.showChangeUserNamePopUp()
                
            }).addDisposableTo(disposeBag)
            
            self.userDisplayPhoto.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: nil, options: .ProgressiveDownload, progress: { rs, es in
                
                let progress = ( rs / es ) * 100
                self.progressLabel.text = "\(progress)%"
                
                }, completed: { image, data, error, finished in
                    
                    self.progressLabel.hidden = true
                    
            })
            
        }
    }
    
    func showChangeUserNamePopUp() {
        
        var inputTextField: UITextField?
        let passwordPrompt = UIAlertController(title: "Change Username", message: "You have selected to change your username.", preferredStyle: UIAlertControllerStyle.Alert)
        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        passwordPrompt.addAction(UIAlertAction(title: "Change", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            SVProgressHUD.showWithStatus("Updating...")
            
            let newName = inputTextField?.text ?? ""
            UserHelper.changeUserName(newName)
            SaveData.sharedInstance.userSavedName = newName
            HugotViewModel().changeHugotAuthor(newName)
            self.usernameButton.setTitle(newName, forState: .Normal)
            
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            delay(3, closure: {
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                SVProgressHUD.dismiss()
            })
            
        }))
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "New Username"
            inputTextField = textField
        })
        
        presentViewController(passwordPrompt, animated: true, completion: nil)
    }
    
    @IBAction func logout() {
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
