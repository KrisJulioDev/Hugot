//
//  HugotTableViewCell.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class HugotTableViewCell: MGSwipeTableCell {

    
    @IBOutlet weak var authorName : UILabel!
    @IBOutlet weak var hugotLine : UILabel!
    @IBOutlet weak var voteCount : UILabel!
    @IBOutlet weak var viewHolder : UIView!
    @IBOutlet weak var likeImage : UIImageView!
    
    let likeImg = UIImage(named: "like")
    let dislikeImg = UIImage(named: "dislike")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayData( data : HugotLine ) { 
        
        self.authorName.text = "Created by @\(data.author)"
        self.hugotLine.text = "\"\(data.line)\""
        self.voteCount.text = "\(data.totalLikes())"
        self.likeImage.image = data.liked() ? likeImg : dislikeImg
    
        changeColorDependsOnLikes(data.totalLikes())
    }
    
    func changeColorDependsOnLikes( likes : Int) {
        
        let rounded = Int(likes / 10) > 12 ? 12 :  Int(likes / 10)
        let color = colorLevels[rounded]
        viewHolder.backgroundColor = color
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.authorName.text = ""
        self.hugotLine.text = ""
        self.voteCount.text = ""
        
    }
}
