//
//  File.swift
//  Arfof Demo
//
//  Created by Qualwebs on 21/02/24.
//


import UIKit

class ChipotleBottomPageViewController: UIPageViewController, UIScrollViewDelegate {

    
    var pageViewControllerList = [UIViewController]()
    var currentIndex: Int = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BottomTabViewController.delegate = self
    
        pageViewControllerList = [
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleMenuViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleFeaturedViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleOrderViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleRewardViewController"),
        ]
        
        setViewControllers([pageViewControllerList[0]], direction: .forward, animated: true, completion: nil)
    }
}


//MARK: Tab Changed
// tab changed in  bottom tab view controller
extension ChipotleBottomPageViewController: BottomTabViewControllerDelegate{
    func tabChanged(index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([pageViewControllerList[index]], direction: direction, animated: true, completion: nil)
        currentIndex = index
    }
}
