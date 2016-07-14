//
//  Utilities.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/5/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit

func delay(val : Double, closure:()->()) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(val * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    
} 