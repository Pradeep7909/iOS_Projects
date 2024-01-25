//
//  ShopPageViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/11/23.
//

import UIKit

protocol ShopPageViewControllerDelegate: AnyObject {
    func didChangePageIndex(index: Int)
}

class ShopPageViewController: UIPageViewController {

    var pageViewControllerList = [UIViewController]()
    var currentIndex: Int = 0
    weak var pageDelegate: ShopPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        pageViewControllerList = [
            self.storyboard!.instantiateViewController(withIdentifier: "ShopProductViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ShopOverviewViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ShopOffersViewController"),
            self.storyboard!.instantiateViewController(withIdentifier: "ShopReviewViewController"),
        ]

        setViewControllers([pageViewControllerList[0]], direction: .forward, animated: true, completion: nil)
    }
    // Enable scrolling for the inner UICollectionView
       func enableInnerCollectionViewScrolling() {
           if let currentViewController = viewControllers?.first as? ShopProductViewController {
               currentViewController.enableCollectionViewScrolling()
           }
       }

       // Reset scrolling for the inner UICollectionView
       func resetInnerCollectionViewScrolling() {
           if let currentViewController = viewControllers?.first as? ShopProductViewController {
               currentViewController.resetCollectionViewScrolling()
           }
       }
}

//for swiping in pages
extension ShopPageViewController: UIPageViewControllerDataSource {
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

//for control tab switching by button
extension ShopPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let index = pageViewControllerList.firstIndex(of: pendingViewControllers.first!) {
            currentIndex = index
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            pageDelegate?.didChangePageIndex(index: currentIndex)
        }
    }
}
