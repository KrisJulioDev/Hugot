//
//  DataService.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/1/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DataService {
    
    static let dataServiceInstance = DataService()
    
    private var BaseReference = FIRDatabase.database().referenceFromURL(BaseURL)
    private var UserReference = FIRDatabase.database().referenceFromURL("\(BaseURL)/users")
    private var HugotReference = FIRDatabase.database().referenceFromURL("\(BaseURL)/hugot")
    
    var BaseRef : FIRDatabaseReference {
        return BaseReference
    }
    
    var UserRef : FIRDatabaseReference {
        return UserReference
    }
    
    var HugotRef : FIRDatabaseReference {
        return HugotReference
    }
    
    
}



