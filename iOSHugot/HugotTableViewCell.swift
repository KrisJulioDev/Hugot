//
//  HugotTableViewCell.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/4/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import RxSwift

class HugotTableViewCell: MGSwipeTableCell {
 
    @IBOutlet weak var authorName : UILabel!
    @IBOutlet weak var hugotLine : UILabel!
    @IBOutlet weak var voteCount : UILabel!
    @IBOutlet weak var viewHolder : UIView!
    @IBOutlet weak var likeImage : UIImageView!
    @IBOutlet weak var profileImg : UIImageView!
    
    @IBOutlet weak var reportButton : UIButton!
    
    let likeImg = UIImage(named: "like")
    let dislikeImg = UIImage(named: "dislike")
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayData( data : HugotLine ) {
        
        self.authorName.text = "@\(data.author)"
        self.hugotLine.text = "\"\(data.line)\""
        self.voteCount.text = "\(data.totalLikes())"
        self.likeImage.image = data.liked() ? likeImg : dislikeImg
    
        UserHelper.fetchUserImage(data.authorID).subscribeNext({[weak self]
            imgURL in
            
            self?.profileImg.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: nil, options: .ProgressiveDownload, progress: { rs, es in
                
                }, completed: { image, data, error, finished in
                    
            })
            
        }).addDisposableTo(disposeBag)
        
        changeColorDependsOnLikes(data.totalLikes())
    }
    
    func changeColorDependsOnLikes( likes : Int) {
        
        let rounded = Int(likes / 10) > 12 ? 12 :  Int(likes / 10)
        let color = colorLevels[rounded]
        viewHolder.backgroundColor = color
        
    }
    
    func addReportButtonCallbackToModel( model : HugotLine, del : FrontPageViewController) {
        self.reportButton.rx_tap.subscribeNext({
            
            let alert = UIAlertController(title: "Report content?", message: "This will be removed from the list and will be investigated. The user who created the content will also be banned if found guilty", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Sure", style: UIAlertActionStyle.Default, handler: {
                _ in
                
                HugotViewModel().removeHugotAndInvestigate(model)
                SaveData.sharedInstance.fronPage?.removeModelToOriginalList(model)
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Destructive, handler: {
                _ in
                
            })
            
            alert.addAction(cancel)
            alert.addAction(ok)
            
            del.present(alert)
            
        }).addDisposableTo(disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.authorName.text = ""
        self.hugotLine.text = ""
        self.voteCount.text = ""
        
        disposeBag = DisposeBag()
        
    }
}
