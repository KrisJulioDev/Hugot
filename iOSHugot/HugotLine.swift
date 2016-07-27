//
//  HugotLines.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/5/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct HugotLine : Equatable {

    let uniqueID : String
    let authorID : String
    let author : String
    let line : String
    let likes : [String]
    let dislikes : [String]
    let dateCreated : Int
    
    init (uniqueID : String, authorID : String,author: String, line : String, likes : [String], dislikes : [String], dateCreated : Int) {
        
        self.uniqueID = uniqueID
        self.authorID = authorID
        self.author = author
        self.line = line
        self.likes = likes
        self.dislikes = dislikes
        self.dateCreated = dateCreated

    }
    
    func markAs () -> HugotLine {
        return HugotLine(uniqueID: uniqueID, authorID: authorID, author: author, line: line, likes: likes, dislikes : dislikes, dateCreated: dateCreated)
    }
    
    func liked () -> Bool  {
        return likes.contains(UserHelper.userId ?? "") ?? false
    }
    func disliked () -> Bool  {
        return dislikes.contains(UserHelper.userId ?? "") ?? false
    }
    
    func totalLikes() -> Int {
        return likes.count - dislikes.count
    }
}

func == (lhs:HugotLine, rhs:HugotLine) -> Bool {
    return lhs.dateCreated == rhs.dateCreated
}