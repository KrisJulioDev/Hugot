//
//  ComposerViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/5/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

class ComposerViewController: MainViewController {

    @IBOutlet weak var hugotLabel : UILabel!
    @IBOutlet weak var hugotField : UITextField!
    
    var hugotViewModel = HugotViewModel()
    
    
    var postButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBarItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Compose"
        
        hugotField.becomeFirstResponder()
        hugotField.autocapitalizationType = UITextAutocapitalizationType.Sentences
    }
    
    func createBarItems() {
        
        let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ComposerViewController.post))
        
        let  cancelButton = UIBarButtonItem(image: UIImage(named: "delete"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposerViewController.cancel))
        
        self.navigationItem.rightBarButtonItem = postButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
        registerRx()
    }

    func registerRx() {
        
        self.hugotField.rx_text.map{ $0.characters.count > 0}.subscribeNext({ [weak self]
            isValid in
            
            if let r = self?.navigationItem.rightBarButtonItem {
                r.enabled = isValid
            }
        }).addDisposableTo(disposeBag)
        
        hugotField.rx_text.subscribeNext({ [weak self]
            input in
            
            if input.characters.count == 0 {
                self?.hugotLabel.text = "\"What's on your mind?\""
            } else {
                self?.hugotLabel.text = "\"\(input)\""
            }
            
        }).addDisposableTo(disposeBag)
        
    }
    
    func post() {
        
        
        hugotViewModel.author      = UserHelper.userDisplayName
        hugotViewModel.authorID    = UserHelper.userId
        hugotViewModel.likes       = Int(0)
        hugotViewModel.line        = self.hugotField.text
        hugotViewModel.dateCreated = FIRServerValue.timestamp()
        
        if let newHugot = hugotViewModel.prepareData() {
            
            let ref = DataService().BaseRef
            let hugotKey = ref.child("hugot").childByAutoId().key
            
            let childUpdates = ["/hugot/\(hugotKey)" : newHugot ]
            
            UIViewController.showHud("Saving")
            ref.updateChildValues(childUpdates, withCompletionBlock: {
                error, reference in
                
                if let error = error{
                    //failed
                    UIViewController.hideHud()
                    debugPrint("error \(error)")
                    
                } else {
                    
                    self.hugotField.text = ""
                    self.hugotLabel.text = ""
                    
                    if let userProfile = SaveData.sharedInstance.userProfile {
                    
                        UserViewModel().incrementPost(userProfile)
                    
                    }
                    
                    self.trackPost()
                    
                    UIViewController.hideHud()
                    self.cancel()
                    
                }
                
            })

        
        }
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
