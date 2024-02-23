//
//  ChipotleOnBoardingPageViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 20/02/24.
//

import UIKit

//protocol which is used to tell about page changed
protocol ChipotleOnBoardingPageViewControllerDelegate: AnyObject {
    func tabPageViewController(_ tabPageViewController: ChipotleOnBoardingPageViewController, didChangeTabToIndex index: Int)
    func pageScrollViewController(_ tabPageViewController: ChipotleOnBoardingPageViewController, didScrollToOffset offset: CGFloat)
}

class ChipotleOnBoardingPageViewController: UIPageViewController, UIScrollViewDelegate{

    var pageViewControllerList = [UIViewController]()
    var currentIndex: Int = 1
    weak var tabDelegate: ChipotleOnBoardingPageViewControllerDelegate?

    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        ChipotleOnBoardingMainViewController.delegate =  self
       

        pageViewControllerList = [
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleOnBoardingFirstViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleOnBoardingSecondViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleOnBoardingThirdViewController"),
        ]
        setViewControllers([pageViewControllerList[1]], direction: .forward, animated: true, completion: nil)
        
        
        disableBounceEffect()
    }
    
    
    //MARK: Bounce off in swipe
    func disableBounceEffect() {
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                scrollView.isMultipleTouchEnabled = false
                break;
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: scrollView.contentOffset.y)
        } else if currentIndex == pageViewControllerList.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: scrollView.contentOffset.y)
        }
        
        let scrollOffset = scrollView.contentOffset.x
        tabDelegate?.pageScrollViewController(self, didScrollToOffset: scrollOffset)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentIndex == pageViewControllerList.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = scrollView.bounds.size.width
        if currentIndex == 0 && scrollView.contentOffset.x > screenWidth {
            scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
        }
        else if currentIndex == pageViewControllerList.count - 1 && scrollView.contentOffset.x < screenWidth {
            scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
        }
    }
}

//MARK: Tab Change MainView
extension ChipotleOnBoardingPageViewController: ChipotleOnBoardingMainViewControllerDelegate{
    func moveToCenterScreen(index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([pageViewControllerList[index]], direction: direction, animated: true){_ in
            self.currentIndex = index
            self.tabDelegate?.tabPageViewController(self, didChangeTabToIndex: self.currentIndex)
        }
    }
}

//MARK: PageView Delegate
// for change as per tab is tapped in main view controller
extension ChipotleOnBoardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = pageViewController.viewControllers?.first else {
            return
        }
        if let currentIndex = pageViewControllerList.firstIndex(of: currentViewController) {
            tabDelegate?.tabPageViewController(self, didChangeTabToIndex: currentIndex)
            self.currentIndex = currentIndex
        }
    }
}

//MARK: PageView DataSource
//for swiping in pages
extension ChipotleOnBoardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllerList.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pageViewControllerList[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllerList.firstIndex(of: viewController), index < pageViewControllerList.count - 1 else {
            return nil
        }
        return pageViewControllerList[index + 1]
    }
}
