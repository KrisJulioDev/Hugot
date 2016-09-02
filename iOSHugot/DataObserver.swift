//
//  DataObserver.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/6/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

protocol DataObserverProtocol {
    func dataAdded(uid : String, data : NSDictionary)
    func dataChanged(uid : String, data : NSDictionary)
}

class DataObserver : DataService  {

//    static let observerInstance = DataObserver()
    var delegate : DataObserverProtocol?
    
    init<T>(delegate : T) {
        self.delegate = delegate as? DataObserverProtocol
    }
    
    func refreshAllObservers() {
        HugotRef.removeAllObservers()
        self.createObserverForHugotLines()
    }
    
    func createObserverForHugotLines() {
        
        HugotRef.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            if snapshot.value is NSDictionary {
                self.delegate?.dataAdded(snapshot.key, data: (snapshot.value as! NSDictionary))
            }
            
        })
        
        
        HugotRef.observeEventType(.ChildChanged, withBlock: {
            snapshot in
            
            if snapshot.value is NSDictionary {
                self.delegate?.dataChanged(snapshot.key, data: (snapshot.value as! NSDictionary))
            }
            
        })
        
    }
    
    
    //MARK: User Observers
    func createObserverForUserData() {
        UserRef.child("\(UserHelper.userId)").observeEventType(.ChildChanged, withBlock: {
            snapshot in
            
            if snapshot.value is NSDictionary {
                
                let newProfile = UserViewModel().generate(snapshot.key, data: (snapshot.value as! NSDictionary))
                SaveData.sharedInstance.userProfile = newProfile
            
            }
        })
    }
    
    func fetchInitialData() -> Observable<[HugotLine]> {
        
        return Observable.create{ [weak self] observer in
            self?.BaseRef.child("hugot").queryOrderedByChild("likes").observeEventType(.Value, withBlock: {
                (hugot : FIRDataSnapshot) in
                
                
                if hugot.value is NSNull { return }
                
                var convertedData = [HugotLine]()
                
                let data = hugot.value as! [String : NSDictionary]
                for d in data {
                    
                    if let newData = HugotViewModel().generate(d.0, data: d.1) {
                        convertedData.append( newData )
                    }
                    
                }
                
                convertedData.sortInPlace({ $0.totalLikes() > $1.totalLikes() })
                
                observer.onNext(convertedData)
                observer.onCompleted()
                
            })
         
            return NopDisposable.instance
        }
        
    }
}











