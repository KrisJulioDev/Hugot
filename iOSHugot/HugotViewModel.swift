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
    var likes : [String]?
    var dislikes : [String]?
    dynamic var dateCreated : AnyObject?
    
    func prepareData () -> NSDictionary? {
        
        self.authorID    = authorID ?? ""
        self.author      = author ?? ""
        self.line        = line ?? ""
        self.likes       = likes ?? [String]()
        self.dislikes       = dislikes ?? [String]()
        self.dateCreated = dateCreated ?? FIRServerValue.timestamp()
        
         return NSDictionary(objects: [author!, authorID!, line!, dateCreated!, likes!, dislikes!], forKeys: ["author", "authorID", "line", "dateCreated", "likes", "dislikes"])
    }
    
    func generate ( id : String, data : NSDictionary ) -> HugotLine? {
        
        self.uniquieID   = id ?? ""
        self.authorID   = data["authorID"] as? String
        self.author      = data["author"] as? String
        self.line        = data["line"] as? String
        self.likes       = data["likes"] as? [String] ?? []
        self.dislikes    = data["dislikes"] as? [String] ?? []
        self.dateCreated = data["dateCreated"] ?? 0
        
        if let u = uniquieID, ai = authorID,a = author, l = line, li = likes, dl = dislikes, dc = dateCreated {
            return HugotLine.init(uniqueID : u, authorID : ai, author : a, line: l, likes: li, dislikes : dl, dateCreated: dc as! Int)
        } else {
            return nil
        }
        
    }
    
    //MARK: REMOVAL
    //remove hugot from the list and add to iinvestigation
    func removeHugotAndInvestigate( model : HugotLine ) {
        let ref = DataService.dataServiceInstance.HugotRef
        let name = "\(model.author)\(BannedName)"
        let key = model.uniqueID
        
        let updates =  ["/\(key)/author" : name]
        ref.updateChildValues(updates)
    }
    
    func incrementLike( hugotModel : HugotLine ) {
        
        let ref = DataService.dataServiceInstance.HugotRef
        let key = hugotModel.uniqueID
        var likes = hugotModel.likes
        
        let userId = UserHelper.userId ?? ""
        likes.append(userId)
        
        if let dl = dislikes, index = dl.indexOf(userId) {
            dislikes?.removeAtIndex(index)
        }
        
        let updates = ["/\(key)/likes" : likes,
                       "/\(key)/dislikes" : dislikes ?? []]
        
        ref.updateChildValues(updates)
        
    }
    
    func decrementLike( hugotModel : HugotLine ) {
        
        let ref = DataService.dataServiceInstance.HugotRef
        let key = hugotModel.uniqueID
        var dislikes = hugotModel.dislikes
        let userId = UserHelper.userId ?? ""
        dislikes.append(userId)
        
        
        if let l = likes, index = l.indexOf(userId) {
            likes?.removeAtIndex(index)
        }
        
        let updates = ["/\(key)/likes" : likes ?? [],
                       "/\(key)/dislikes" : dislikes]
        
        ref.updateChildValues(updates)
        
    }
    
    
    func changeHugotAuthor( newName : String ) {
        DataObserver.dataServiceInstance.HugotRef.queryOrderedByChild("authorID").queryEqualToValue(UserHelper.userId).observeEventType(.ChildAdded, withBlock: {
            (hugot : FIRDataSnapshot) in
            
            if hugot.value is NSNull { return }
            
            guard hugot.value is NSDictionary else { return }
            
            self.updateName(hugot.key, name: newName)
            
        })
    }
    
    internal func updateName(key : String, name : String = "") {
        
        let ref = DataService.dataServiceInstance.HugotRef
        
        let updates = ["/\(key)/author" : name]
        
        ref.updateChildValues(updates)

    }
}
