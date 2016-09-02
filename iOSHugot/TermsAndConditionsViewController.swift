//
//  TermsAndConditionsViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/27/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {
    
    
    var delegate : RegisterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func agree() {
        delegate?.isAgreed = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func decline() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
