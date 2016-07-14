//
//  UserModel.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/6/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit

struct UserModel {

    let uniqueID : String
    let displayName : String
    let displayPhotoURL : String
    let userHearts : Int
    let userPosts : Int
    let dateCreated : Int
    
    init(uid : String, dName : String, dPU : String, uH : Int, uP : Int, dC : Int) {
        
        self.uniqueID = uid
        self.displayName = dName
        self.displayPhotoURL = dPU
        self.userHearts = uH
        self.userPosts = uP
        self.dateCreated = dC
        
    }
    
    func markAs() -> UserModel {
        return UserModel.init(uid:uniqueID, dName: displayName, dPU: displayPhotoURL, uH: userHearts, uP: userPosts,dC: dateCreated)
    }
    
}
