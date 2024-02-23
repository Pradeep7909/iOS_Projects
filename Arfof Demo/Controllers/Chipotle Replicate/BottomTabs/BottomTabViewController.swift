//
//  BottomTabViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 21/02/24.
//

import UIKit

protocol BottomTabViewControllerDelegate: AnyObject {
    func tabChanged(index : Int)
}


class BottomTabViewController: UIViewController {

    //MARK: Variables
    var currentIndex = 0
    static var delegate: BottomTabViewControllerDelegate?
    
    //MARK: IBOutlets
    @IBOutlet weak var menuTabLabel: UILabel!
    @IBOutlet weak var featuredTabLabel: UILabel!
    @IBOutlet weak var orderTabLabel: UILabel!
    @IBOutlet weak var rewardTabLabel: UILabel!
    
    
    @IBOutlet weak var menuTabLineWidth: NSLayoutConstraint!
    @IBOutlet weak var featureTabLineWidth: NSLayoutConstraint!
    @IBOutlet weak var orderTabLineWidth: NSLayoutConstraint!
    @IBOutlet weak var rewardTabLineWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()

    }
    
    //MARK: IBAction
    @IBAction func cancelButtonAction(_ sender: Any) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func menuActionButton(_ sender: Any) {
        bottomTabChange(index: 0)
    }
    
    
    @IBAction func featureButtonAction(_ sender: Any) {
        bottomTabChange(index: 1)
    }
    
    @IBAction func orderButtonAction(_ sender: Any) {
        bottomTabChange(index: 2)
    }
    
    @IBAction func rewardButtonAction(_ sender: Any) {
        bottomTabChange(index: 3)
    }
    
    
    //MARK: Functions
    func initialize (){
        menuTabLineWidth.constant = 0
        featureTabLineWidth.constant = 0
        orderTabLineWidth.constant = 0
        rewardTabLineWidth.constant = 0
        
        tabAtIndex(index: currentIndex)?.textColor = K_CHIPOTLE_RED_COLOR
        tabLineAtIndex(index: currentIndex)?.constant = 20
        BottomTabViewController.delegate?.tabChanged(index: currentIndex)
    }
    
    func bottomTabChange(index : Int){
        changeColor(currentIndex: currentIndex, nextIndex: index)
        currentIndex = index
        BottomTabViewController.delegate?.tabChanged(index: index)
    }
    
    func changeColor(currentIndex :Int , nextIndex : Int){
        tabAtIndex(index: currentIndex)?.textColor = K_CHIPOTLE_DARK_COLOR
        tabAtIndex(index: nextIndex)?.textColor = K_CHIPOTLE_RED_COLOR
        guard let currentTabLine = tabLineAtIndex(index: currentIndex),
              let nextTabLine = tabLineAtIndex(index: nextIndex) else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            currentTabLine.constant = 0
            nextTabLine.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    func tabAtIndex(index: Int) -> UILabel? {
        switch(index) {
        case 0:
            return menuTabLabel
        case 1:
            return featuredTabLabel
        case 2:
            return orderTabLabel
        case 3:
            return rewardTabLabel
        default:
            return nil
        }
    }
    
    func tabLineAtIndex(index : Int) -> NSLayoutConstraint?{
        switch(index) {
        case 0:
            return menuTabLineWidth
        case 1:
            return featureTabLineWidth
        case 2:
            return orderTabLineWidth
        case 3:
            return rewardTabLineWidth
        default:
            return nil
        }
    }
}
