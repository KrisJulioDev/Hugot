//
//  UserViewModel.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/6/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserViewModel {

    dynamic var uniqueID : String = ""
    dynamic var displayName : String = ""
    dynamic var displayPhotoURL : String = ""
    
    var userHearts : Int = 0
    var userPosts : Int = 0
    var dateCreated : AnyObject?

    func prepareData() -> NSDictionary? {
        
        self.uniqueID = uniqueID ?? ""
        self.displayName = displayName ?? ""
        self.displayPhotoURL = displayPhotoURL ?? ""
        self.dateCreated = dateCreated ?? 0
        
        return NSDictionary(objects: [displayName, displayPhotoURL, userHearts, userPosts, dateCreated! ],
                            forKeys: ["name", "photoURL", "hearts", "posts", "dateCreated"])
    }
    
    //MARK: Save new user
    func saveNewUser() {
        
        checkIfUserExists(UserHelper.userId!, saveBlock: { _ in
            
            let newUser = UserViewModel()
            newUser.displayName = UserHelper.userDisplayName 
            
            newUser.userHearts = InitialHearts
            newUser.userPosts  = 0
            newUser.dateCreated = FIRServerValue.timestamp()
            
            if let data = newUser.prepareData() {
                
                let ref = DataService.dataServiceInstance.UserRef
                let key = UserHelper.userId ?? ""
                let childUpdate = ["\(key)" : data]
                
                UserHelper.saveUniqueIDForPushNotif(key)
                
                ref.updateChildValues(childUpdate, withCompletionBlock: {
                    error, reference in
                    
                    if error != nil {
                        debugPrint("error occured \(error)")
                        
                        let userModel = UserModel.init(uid: key, dName: newUser.displayName, dPU: newUser.displayPhotoURL, uH: newUser.userHearts, uP: newUser.userPosts, dC: (newUser.dateCreated as! Int))
                        
                        SaveData.sharedInstance.userProfile = userModel
                    }
                    
                })
            }
        })
        
    }
    
    //MARK: Generate new user
    func generate(uid : String, data : NSDictionary) -> UserModel {
        
        let dateCreated = data["dateCreated"] as? Int  ?? 0
        let displayName = data["name"] as? String ?? ""
        let displayPhotoURL = data["photoURL"] as? String ?? ""
        let hearts = data["hearts"] as? Int ?? 50
        let posts = data["posts"] as? Int  ?? 0
        
        return UserModel.init(uid: uid, dName: displayName, dPU: displayPhotoURL, uH: hearts, uP: posts, dC: dateCreated)
    }
    
    //MARK : Model helper
    func checkIfUserExists ( id : String, saveBlock : () -> () ) {
         
        DataService.dataServiceInstance.UserRef.queryOrderedByKey().queryEqualToValue(id).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if snapshot.value is NSNull {
                saveBlock()
            } else {
                if let data = snapshot.value as? [String : NSDictionary] {
                for d in data {
                    let userData = self.generate(d.0, data: d.1)
                    SaveData.sharedInstance.userProfile = userData
                    SaveData.sharedInstance.userSavedName = userData.displayName
                }
                }
            }
            
        })
        
    }
    
    func queryUserWithID ( id : String, completionBlock : (AnyObject? ) -> () ) {
        DataService.dataServiceInstance.UserRef.queryOrderedByKey().queryEqualToValue(id).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
    
                completionBlock(snapshot.value)
            
        })
    }
    
    func incrementPost( userModel : UserModel ) {
        
        let ref = DataService.dataServiceInstance.UserRef
        let key = userModel.uniqueID
        
        ref.child("/\(key)/posts").setValue(userModel.userPosts + 1)
        
    }
    
    func incrementDecrementLikes(isIncrement : Bool, userID : String, valueChange : Int = 1 ) {
        
        debugPrint(userID)
        let ref = DataService.dataServiceInstance.UserRef
        let key = userID
        
        queryUserWithID(userID, completionBlock: { value in
            
            if value is NSNull { return }
            
            if let data = value as? [String : NSDictionary] {
                for d in data {
                    let userModel = self.generate(d.0, data: d.1)
                    ref.child("/\(key)/hearts").setValue(userModel.userHearts + (isIncrement ? valueChange : -valueChange))
                }
            }
        })
    }
    
    
}
