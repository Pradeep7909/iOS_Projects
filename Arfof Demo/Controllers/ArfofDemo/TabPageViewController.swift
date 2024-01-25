//
//  TabPageViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/16/23.
//

import UIKit

//protocol which is used to tell about tab is switched in mainView controller and then changes is defined in delegate
protocol TabPageViewControllerDelegate: AnyObject {
    func tabPageViewController(_ tabPageViewController: TabPageViewController, didChangeTabToIndex index: Int)
}

class TabPageViewController: UIPageViewController {

    var pageViewControllerList = [UIViewController]()
    var currentIndex: Int = 0
    weak var tabDelegate: TabPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        pageViewControllerList = [
            self.storyboard!.instantiateViewController(withIdentifier: "HomeScreenViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ExploreViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "DashBoardViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "MyOrdersViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "MapViewController"),
        ]

        setViewControllers([pageViewControllerList[0]], direction: .forward, animated: true, completion: nil)
    }

}

// for change as per tab is tapped in main view controller
extension TabPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = pageViewController.viewControllers?.first else {
            return
        }
        if let currentIndex = pageViewControllerList.firstIndex(of: currentViewController) {
            tabDelegate?.tabPageViewController(self, didChangeTabToIndex: currentIndex)
        }
    }
}
