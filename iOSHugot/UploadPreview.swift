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
    @IBOutlet weak var createdLabel : UILabel!
    
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
        self.siteLabel.hidden = true
        self.createdLabel.hidden = true
        
        self.needsUpdateConstraints()
    }
    
    func applyStroke( text : String ) {
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : 0,
            ]
        
        hugotLine.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
    }

}
