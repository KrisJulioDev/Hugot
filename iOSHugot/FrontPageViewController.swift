//
//  FrontPageViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/1/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MGSwipeTableCell
import DGElasticPullToRefresh
import SVProgressHUD

class FrontPageViewController: MainViewController, UITableViewDelegate, DataObserverProtocol, MGSwipeTableCellDelegate, FBSDKSharingDelegate, UIScrollViewDelegate  {
    
    //Reactive TableView
    @IBOutlet weak var tableView : UITableView!
    
    var hugotLists : Variable<[HugotLine]> = Variable([])
    
    var hugotViewModel = HugotViewModel()
    var dataObserver : DataObserver?
    
    /* bar button items */
    var trendingBarItem : UIBarButtonItem?
    var yoursBarItem : UIBarButtonItem?
    var newBarItem : UIBarButtonItem?
    
    var isFetching : Bool = false
    
    enum FilterState : Int {
        case Trending = 0
        case New
        case Yours
        
        var buttonItem : UIBarButtonItem {
            switch self {
            case .Trending:
                return UIBarButtonItem(image: UIImage(named: "trend"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Done, target: nil, action: #selector(FrontPageViewController.changeSorting))
            case .New:
                return UIBarButtonItem(image: UIImage(named: "new"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Done, target: nil, action: #selector(FrontPageViewController.changeSorting))
            case .Yours:
                return UIBarButtonItem(image: UIImage(named: "yours"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Done, target: nil, action: #selector(FrontPageViewController.changeSorting))
                
            }
        }
        
        var title : String {
            switch self {
            case .Trending:
                return "Trending lists"
            case .New:
                return "Newly created"
            case .Yours:
                return "Here's what you've created"
            }
        }
    }
    
    var filterState : FilterState = FilterState.Trending
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.showProgress("Hinuhugot...")
        self.setupRxObservers()
        self.fetchInitialData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // add gesture recognizer to title
        addTitleCallback()
        setupBarButtons()
    }
    
    func  addTitleCallback() {
        
        let titleButton = UIButton()
//        titleButton.setTitle("@\(UserHelper.userDisplayName.stringByReplacingOccurrencesOfString(" " , withString: ""))", forState: .Normal)
        titleButton.setTitle("@MisterHugot", forState: .Normal)
        
        titleButton.titleLabel?.font = UIFont(name: "Kohinoor Bangla", size: 20)
        titleButton.addTarget(self, action: #selector(FrontPageViewController.showUserProfile), forControlEvents: .TouchUpInside)
        
        self.navigationItem.titleView = titleButton
    }
    
    
    func fetchInitialData() {
        dataObserver = DataObserver(delegate: self) 
        
        // Observer for new data from the server
        dataObserver?.createObserverForHugotLines()
        dataObserver?.createObserverForUserData()
    }
    
    //MARK: RX Setup
    func setupRxObservers() {
        
        // Setup tableview for data display
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            // we just refresh if there's no data on hugotLists, since we are always listening to childAdded and childChange events
            if self?.hugotLists.value.count == 0 {
                self?.dataObserver?.refreshAllObservers()
            }
            
            self?.trackRefreshed()
            self?.tableView.dg_stopLoading()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.1))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        self.tableView.rx_setDelegate(self).addDisposableTo(disposeBag)
        
        hugotLists.asObservable().bindTo(self.tableView.rx_itemsWithCellIdentifier(HugotCellIdentifier)) {
            (index, element, cell) in
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if cell is HugotTableViewCell {
                (cell as! HugotTableViewCell).displayData(element)
                cell.editing = false
                
            }
            
            if cell is MGSwipeTableCell {
                let cellx = cell as! MGSwipeTableCell
                cellx.delegate = self
                
                
            }
            
            }.addDisposableTo(disposeBag)
        
        
        self.tableView.rx_itemSelected.subscribeNext({
            indexPath in
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? HugotTableViewCell
            cell?.viewHolder.alpha = 0.5
            delay(0.2, closure: {
                 cell?.viewHolder.alpha = 0.8
            })
            
            if let model : HugotLine = self.hugotLists.value[indexPath.row] {
                self.shareOnFacebook(model)
            }
            
        }).addDisposableTo(disposeBag)
    }
    
    func setupBarButtons() {
        
        let compose = UIBarButtonItem(image: UIImage(named: "new_file"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Done, target: self, action: #selector(FrontPageViewController.composeNewHugot))
        
        self.navigationItem.rightBarButtonItem = compose
        
        self.navigationItem.leftBarButtonItem = self.filterState.buttonItem
        self.navigationItem.leftBarButtonItem!.target = self
    }
    
    
    //MARK:Transitions
    func composeNewHugot() {
        let composeVC = ComposerViewController.instanceWithDefaultNib()
        let nav = composeVC.commonNavigationController()
        
        self.trackCompose()
        self.present(nav)
    }
    
    func changeSorting() {
        
        let newValue = (self.filterState.rawValue + 1) >= 3 ? 0 : (self.filterState.rawValue + 1)
        self.filterState = FilterState(rawValue: newValue)!
        
        self.sortAndFilterByPreference()
        self.trackFilter()
        
        self.navigationItem.leftBarButtonItem = self.filterState.buttonItem
        self.navigationItem.leftBarButtonItem!.target = self
        
    }
    
    func showUserProfile() {
        let profileVC = UserProfileViewController.instanceWithDefaultNib()
        let nav = profileVC.commonNavigationController()
        
        self.trackShowProfile()
        self.present(nav)
    }
    
    //MARK: Facebook share action
    func shareOnFacebook ( model : HugotLine ) {
        
        if let preView = NSBundle.mainBundle().loadNibNamed("UploadPreview", owner: self, options: nil)[0] as? UIView {
            
            let height = self.view.frame.height / 2
            let width = self.view.frame.width   - 30
            
            preView.frame = CGRectMake(self.view.frame.midX - width / 2, self.view.frame.midY - height, width, height)
            
            let blackScreen = UIView(frame: self.view.frame)
            blackScreen.backgroundColor = .blackColor()
            blackScreen.alpha = 0
            preView.alpha = 0
            
            self.view.addSubview(blackScreen)
            self.view.addSubview(preView)
            
            UIView.animateWithDuration(0.3, animations: {
                
                blackScreen.alpha = 0.8
                preView.alpha = 1
                
                preView.frame.origin.y = self.view.frame.midY - height / 2
                
            })
            
            let uploadPreview = preView as? UploadPreview
            uploadPreview?.hugotLine.text = model.line
            
            //Upload button
            uploadPreview?.uploadButton.rx_tap.subscribeNext({[weak self]
                _ in
                uploadPreview?.actionView.hidden = true
                uploadPreview?.siteLabel.hidden = false
                UIGraphicsBeginImageContextWithOptions(preView.bounds.size, false, 0.0)
                preView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let screenShot = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                
                self?.shareImageOnFacebook(screenShot)
                
                uploadPreview?.actionView.hidden = false
                uploadPreview?.siteLabel.hidden = true
                
            }).addDisposableTo(disposeBag)
            
            //Close button
            uploadPreview?.closeButton.rx_tap.subscribeNext({
                _ in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    preView.frame.origin.y = self.view.frame.midY - height
                    
                    blackScreen.alpha = 0
                    preView.alpha = 0
                    
                    }, completion: {
                        bool in
                        
                        blackScreen.removeFromSuperview()
                        preView.removeFromSuperview()
                })
                
            }).addDisposableTo(disposeBag)
        }

        
    }
    
    func  shareImageOnFacebook( image : UIImage ) {
        
        let photo = FBSDKSharePhoto()
        photo.image = image
        photo.userGenerated = true
        
        let photoContent = FBSDKSharePhotoContent()
        photoContent.photos = [photo]
        
        let shareDialog = FBSDKShareDialog()
        shareDialog.shareContent = photoContent
        shareDialog.show()
        
    }
    
    //MARK: Facebook delegate mthods
    func sharerDidCancel(sharer: FBSDKSharing!) {
        SVProgressHUD.showErrorWithStatus("Sharing cancelled")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        SVProgressHUD.showErrorWithStatus("Sharing failed")
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        SVProgressHUD.showWithStatus("Shared succesfully")
    }
    
    //MARK: Protocols
    func dataAdded(uid: String, data: NSDictionary) {
   
        if let h = HugotViewModel().generate(uid, data: data) {
            self.hugotLists.value.append(h)
            self.hugotLists.value.sortInPlace({ return $0.totalLikes() > $1.totalLikes() })
        }
        
        SVProgressHUD.dismiss()
    }
    
    func dataChanged(uid: String, data: NSDictionary) {
        
        let existingModel = self.hugotLists.value.filter({ $0.uniqueID == uid})
        
        if existingModel.count > 0 {
            
            if let h = HugotViewModel().generate(uid, data: data), index = self.hugotLists.value.indexOf(existingModel.first!) {
                self.hugotLists.value[index] = h
                self.hugotLists.value.sortInPlace({ return $0.totalLikes() > $1.totalLikes() })
                
            }
        }
        
    }
    
    //MARK: Swipe delegates
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        
        swipeSettings.transition = MGSwipeTransition.Drag;
        swipeSettings.keepButtonsSwiped = false;
        expansionSettings.buttonIndex = 0;
        expansionSettings.threshold = 1.0;
        expansionSettings.expansionLayout = MGSwipeExpansionLayout.Center;
        expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunction.CubicIn;
        expansionSettings.fillOnTrigger = false;
        
        
        if direction == MGSwipeDirection.LeftToRight {
            return [MGSwipeButton(title: "", icon: UIImage(named:"dislike"), backgroundColor: UIColor.clearColor())]
        } else if direction == MGSwipeDirection.RightToLeft {
            return [MGSwipeButton(title: "", icon: UIImage(named:"like"), backgroundColor: UIColor.clearColor())]
        }
        
        return nil
    }
    
    func swipeTableCellWillEndSwiping(cell: MGSwipeTableCell!) {
        
        let indexPath = self.tableView.indexPathForCell(cell)
        
        let index =  indexPath?.row ?? 0
        let hugotModel = self.hugotLists.value[ index ]
       
        if cell.swipeState == MGSwipeState.ExpandingLeftToRight {
            
            self.hugotViewModel.decrementLike(hugotModel)
            self.trackUnlike()
            
            UserViewModel().incrementDecrementLikes(false, userID: hugotModel.authorID ?? "")
            
        } else if cell.swipeState == MGSwipeState.ExpandingRightToLeft {
            
            self.hugotViewModel.incrementLike(hugotModel)
            self.trackLike()
            
            UserViewModel().incrementDecrementLikes(true, userID: hugotModel.authorID ?? "")
            
        }
        
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        
        let indexOfCell = self.tableView.indexPathForCell(cell)
        return true
        if let hugotLine : HugotLine = self.hugotLists.value[(indexOfCell?.row)!]  {
            
            if direction == .RightToLeft && hugotLine.liked() {
                return false
            } else if direction == .LeftToRight && hugotLine.disliked() {
                return false
            }
            
        }

        return true
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    //MARK: Sorting
    func sortAndFilterByPreference() {
        
        self.showProgress(self.filterState.title)
        delay(1, closure: { self.hideProgress() })
        
        switch self.filterState {
        case .New:
            self.hugotLists.value.sortInPlace({ $0.dateCreated > $1.dateCreated })
            break
        case .Trending:
            self.hugotLists.value.sortInPlace({ $0.totalLikes() > $1.totalLikes() })
            break
        case .Yours:
            self.hugotLists.value = self.hugotLists.value.filter({ $0.author == UserHelper.userDisplayName })
            break
        }
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
}
