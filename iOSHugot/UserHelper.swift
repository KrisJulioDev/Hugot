//
//  UserHelper.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import FirebaseAuth
import Firebase
import Batch

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

class UserHelper: NSObject {

    // Facebook Data //
    static var isAuthenticated : Bool {
        return FIRAuth.auth()?.currentUser?.uid != nil
    }
    
    static var userId : String? {
        return FIRAuth.auth()?.currentUser?.uid ?? nil
    }
    
    static var userDisplayName : String {
        return FIRAuth.auth()?.currentUser?.displayName ?? "" 
    }
    
    static var userDisplayPhotoURL : NSURL? {
        return FIRAuth.auth()?.currentUser?.photoURL ?? nil
    }
    
    
    
    static func saveUniqueIDForPushNotif( uid : String) {
        
        let editor = BatchUser.editor()
        editor.setIdentifier(uid)
        editor.save()
        
    }
    
    static func removeIDForPushNotif() {
        let editor = BatchUser.editor()
        editor.setIdentifier(nil)
        editor.save()
    }
    
    
    static func fetchUserImage(authorID : String) -> Observable<String> {
        
        return Observable.create { observer in
            
            DataObserver.dataServiceInstance.UserRef.child(authorID).observeEventType(.Value, withBlock: {
                (author : FIRDataSnapshot) in
                
                if author.value is NSNull  { return }
                
                if let v = author.value, imgURL = v["photoURL"] where imgURL is String {
                    observer.onNext(imgURL as! String)
                    observer.onCompleted()
                }
                
            })
            
            return NopDisposable.instance
        }
        
    }
    
    static func fetchUserName(authorID : String) -> Observable<String> {
        
        return Observable.create { observer in
            
            DataObserver.dataServiceInstance.UserRef.child(authorID).observeEventType(.Value, withBlock: {
                (author : FIRDataSnapshot) in
                
                if author.value is NSNull  { return }
                
                if let v = author.value, name = v["name"] where name is String {
                    observer.onNext(name as! String)
                    observer.onCompleted()
                }
                
            })
            
            return NopDisposable.instance
        }
        
    }
    
    static func changeUserName(newUserName : String ) {
        
        let ref = DataService.dataServiceInstance.UserRef
        
        let userId = UserHelper.userId ?? ""
        
        let updates = ["/\(userId)/name" : newUserName]
        
        ref.updateChildValues(updates)
        
    }
}

class SaveData {
    
    static let sharedInstance = SaveData()
    
    var userProfile : UserModel?
    var fronPage : FrontPageViewController?
    var originalLists = [HugotLine]()
    
    var userSavedName : String {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "userName")
            if let fp = self.fronPage {
                fp.addTitleCallback()
            }
        }
        
        get {
            return  NSUserDefaults.standardUserDefaults().valueForKey("userName") as? String ?? ""
        }
    }
}