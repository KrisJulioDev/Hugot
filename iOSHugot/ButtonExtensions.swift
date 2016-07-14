//
//  ButtonExtensions.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/6/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit

class ButtonExtensions: NSObject {

}

extension UIButton {
    
    func shake() {
        
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPointMake(self.center.x - 5, self.center.y)
        let from_value:NSValue = NSValue(CGPoint: from_point)
        
        let to_point:CGPoint = CGPointMake(self.center.x + 5, self.center.y)
        let to_value:NSValue = NSValue(CGPoint: to_point)
        
        
        shake.fromValue = from_value
        shake.toValue = to_value
        
        self.layer.addAnimation(shake, forKey: "position")
        
    }
    
    func removeShake() {
        self.layer.removeAnimationForKey("position")
    }
    
}