//
//  ChipotleOnBoardingSecondPageViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 21/02/24.
//

import UIKit

//protocol which is used screen changed.
protocol ChipotleOnBoardingSecondPageViewControllerDelegate: AnyObject {
    func tabChangeController(_ tabPageViewController: ChipotleOnBoardingSecondPageViewController, didChangeTabToIndex index: Int)
    func secondPageScrollViewController(_ tabPageViewController: ChipotleOnBoardingSecondPageViewController, didScrollToOffset offset: CGFloat)
}


class ChipotleOnBoardingSecondPageViewController: UIPageViewController, UIScrollViewDelegate {

    
    var pageViewControllerList = [UIViewController]()
    var currentIndex: Int = 1
    static var tabDelegate: ChipotleOnBoardingSecondPageViewControllerDelegate?
    
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.delegate = self
        self.dataSource = self
        ChipotleOnBoardingSecondAboveViewController.delegate = self

        pageViewControllerList = [
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleOnBoardingSecondAboveViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ChipotleOnBoardingSecondBelowViewController"),
        ]
        
        setViewControllers([pageViewControllerList[1]], direction: .forward, animated: true, completion: nil)
        
        
        disableBounceEffect()
    }
    
    //MARK: Bounce off in swipe
    func disableBounceEffect() {
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break;
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.y < scrollView.bounds.size.height {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.bounds.size.height)
        } else if currentIndex == pageViewControllerList.count - 1 && scrollView.contentOffset.y > scrollView.bounds.size.height {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.bounds.size.height)
        }
        
        let scrollOffset = scrollView.contentOffset.y
        ChipotleOnBoardingSecondPageViewController.tabDelegate?.secondPageScrollViewController(self, didScrollToOffset: scrollOffset)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (currentIndex == 0 && scrollView.contentOffset.y <= scrollView.bounds.size.height) {
            targetContentOffset.pointee = CGPoint(x: 0, y: scrollView.bounds.size.height)
        } else if (currentIndex == pageViewControllerList.count - 1 && scrollView.contentOffset.y >= scrollView.bounds.size.height) {
            targetContentOffset.pointee = CGPoint(x: 0, y: scrollView.bounds.size.height)
        }
    }
}

//MARK: PageView Delegate
// for change screen complete..
extension ChipotleOnBoardingSecondPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = pageViewController.viewControllers?.first else {
            return
        }
        if let currentIndex = pageViewControllerList.firstIndex(of: currentViewController) {
            self.currentIndex = currentIndex
            ChipotleOnBoardingSecondPageViewController.tabDelegate?.tabChangeController(self, didChangeTabToIndex: self.currentIndex)
        }
    }
}

//MARK: PageView DataSource
//for swiping in pages
extension ChipotleOnBoardingSecondPageViewController: UIPageViewControllerDataSource {
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


//MARK: Tab Change Delegate
extension ChipotleOnBoardingSecondPageViewController: OnBoardingSecondPageControllerDelegate{
    func moveToBelowPage() {
        setViewControllers([pageViewControllerList[1]], direction: .forward, animated: true){ _ in
            self.currentIndex = 1
            ChipotleOnBoardingSecondPageViewController.tabDelegate?.tabChangeController(self, didChangeTabToIndex: self.currentIndex)
        }
       
    }
}
