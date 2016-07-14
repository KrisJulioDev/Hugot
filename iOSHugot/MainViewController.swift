//
//  MainViewController.swift
//  iOSHugot
//
//  Created by Kris Julio on 7/5/16.
//  Copyright © 2016 Virem. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseDatabase

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFontOnNavBar()
        addBackgroundImage()
    }
    
    func setupFontOnNavBar() {

    }
    
    func addBackgroundImage() {
        let image = UIImageView(image: UIImage(named: "23414-NUICEV"))
        image.frame = self.view.frame
        image.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.view.addSubview(image)
    }
    
    func present( vc : UIViewController) {
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func push ( vc : UIViewController ) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Getter
    func commonNavigationController () -> UINavigationController {
        let nav = UINavigationController(rootViewController: self)
        nav.navigationBar.barTintColor = grayBarColor
        nav.navigationBar.tintColor = .whiteColor()
        
        nav.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Avenir Next", size: 20)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        return nav
    }
    
    //Mark: Progress HUd
    func showProgress(label : String = "") {
        UIViewController.showHud(label)
    } 
    
    func hideProgress() {
        UIViewController.hideHud()
    }
    
    //Mark : Reference
    var BaseReference : FIRDatabaseReference {
        return DataService.dataServiceInstance.BaseRef
    }
    
    //Tracking
    func trackCompose() {
        BatchUser.trackEvent("Compose")
    }
    func trackPost() {
        BatchUser.trackEvent("Posted")
    }
    func trackFilter() {
        BatchUser.trackEvent("Filter")
    }
    func trackShowProfile() {
        BatchUser.trackEvent("ShowProfile")
    }
    func trackLike() {
        BatchUser.trackEvent("Liked")
    }
    func trackUnlike() {
        BatchUser.trackEvent("Unliked")
    }
    func trackLogout() {
        BatchUser.trackEvent("Logout")
    }
    func trackRefreshed() {
        BatchUser.trackEvent("Refreshed")
    }
    
}
