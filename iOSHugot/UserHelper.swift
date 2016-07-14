//
//  UserHelper.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import FirebaseAuth
import Batch

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
}

class SaveData {
    
    static let sharedInstance = SaveData()
    
    var userProfile : UserModel?
}