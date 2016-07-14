//
//  UploadPreview.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/12/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit

class UploadPreview: UIView {
    
    @IBOutlet weak var closeButton : UIButton!
    @IBOutlet weak var uploadButton : UIButton!
    @IBOutlet weak var changeImage : UIButton!
    
    @IBOutlet weak var hugotLine : UILabel!
    @IBOutlet weak var hugotImage : UIImageView!
    
    @IBOutlet weak var actionView : UIView!
    @IBOutlet weak var siteLabel : UILabel!
    
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
        self.siteLabel.hidden = true
        
        self.needsUpdateConstraints()
    }

}
