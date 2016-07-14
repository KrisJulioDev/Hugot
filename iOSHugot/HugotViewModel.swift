//
//  HugotViewModel.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/6/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HugotViewModel {

    dynamic var uniquieID : String?
    dynamic var authorID : String?
    dynamic var author : String?
    dynamic var line : String?
    var likes : Int?
    dynamic var dateCreated : AnyObject?
    
    func prepareData () -> NSDictionary? {
        
        self.authorID    = authorID ?? ""
        self.author      = author ?? ""
        self.line        = line ?? ""
        self.likes       = likes ?? 0
        self.dateCreated = dateCreated ?? FIRServerValue.timestamp()
        
         return NSDictionary(objects: [author!, authorID!, line!, dateCreated!, likes!], forKeys: ["author", "authorID", "line", "dateCreated", "likes"])
    }
    
    func generate ( id : String, data : NSDictionary ) -> HugotLine? {
        
        self.uniquieID   = id ?? ""
        self.authorID   = data["authorID"] as? String
        self.author      = data["author"] as? String
        self.line        = data["line"] as? String
        self.likes       = data["likes"] as? Int
        self.dateCreated = data["dateCreated"] ?? 0
        
        if let u = uniquieID, ai = authorID,a = author, l = line, li = likes, dc = dateCreated {
            return HugotLine.init(uniqueID : u, authorID : ai, author : a, line: l, likes: li, dateCreated: dc as! Int)
        } else {
            return nil
        }
        
    }
    
    
    func incrementLike( hugotModel : HugotLine ) {
        
        let ref = DataService.dataServiceInstance.HugotRef
        let key = hugotModel.uniqueID
        
        ref.child("/\(key)/likes").setValue(hugotModel.likes + 1)
        
    }
    
    func decrementLike( hugotModel : HugotLine ) {
        
        let ref = DataService.dataServiceInstance.HugotRef
        let key = hugotModel.uniqueID
        
        ref.child("/\(key)/likes").setValue(hugotModel.likes - 1)
        
    }
}
