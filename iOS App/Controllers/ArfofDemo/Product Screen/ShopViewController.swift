//
//  ShopViewController.swift
//  iOS App
//
//  Created by Guest on 12/11/23.
//

import UIKit

class ShopViewController: UIViewController, UIScrollViewDelegate, ShopPageViewControllerDelegate {
    
    var pageViewController: ShopPageViewController?
    let screenWidth = UIScreen.main.bounds.width
    
    //MARK: outlets
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var currentPageTabView: UIView!
    
    @IBOutlet weak var productTabView: UIView!
    @IBOutlet weak var overviewTabView: UIView!
    @IBOutlet weak var offerTabView: UIView!
    @IBOutlet weak var reviewTabView: UIView!
    
    @IBOutlet weak var currentPageTabViewLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfContainerViewForPages: NSLayoutConstraint!
    
    
    //MARK: viewLoad function
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addGestures()
    }
    
        
    //MARK: Screen setup
    func addGestures(){
        // added gesture on back button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        
        //gesture on tab btn view
        let productTab = UITapGestureRecognizer(target: self, action: #selector(productsTapped))
        productTabView.addGestureRecognizer(productTab)
        let overviewTab = UITapGestureRecognizer(target: self, action: #selector(overviewTapped))
        overviewTabView.addGestureRecognizer(overviewTab)
        let offerTab = UITapGestureRecognizer(target: self, action: #selector(offersTapped))
        offerTabView.addGestureRecognizer(offerTab)
        let reviewTab = UITapGestureRecognizer(target: self, action: #selector(reviewTapped))
        reviewTabView.addGestureRecognizer(reviewTab)
    }
    


    // MARK: - Functions
    
    //gesture (on tapped )functions
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    @objc func productsTapped(){
       btnBackgroundShow(sender : productTabView)
        changePage(toIndex: 0)
        changebarButtonUnderLine(buttonNo: 0)
    }
    @objc func overviewTapped(){
        btnBackgroundShow(sender : overviewTabView)
        changePage(toIndex: 1)
        changebarButtonUnderLine(buttonNo: 1)
    }
    @objc func offersTapped(){
       btnBackgroundShow(sender : offerTabView)
        changePage(toIndex: 2)
        changebarButtonUnderLine(buttonNo: 2)
    }
    @objc func reviewTapped(){
       btnBackgroundShow(sender : reviewTabView)
        changePage(toIndex: 3)
        changebarButtonUnderLine(buttonNo: 3)
    }
    
    
    //header view change when scroll 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == myScrollView{
            let scrollOffset = scrollView.contentOffset.y

            if scrollOffset > 0 {
                headerView.backgroundColor = UIColor.white
                headerView.layer.shadowColor = UIColor.gray.cgColor
                headerView.layer.shadowOpacity = 0.5
                headerView.layer.shadowRadius = 5
                headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
            }
            else {
                headerView.backgroundColor = UIColor.clear
                headerView.layer.shadowColor = UIColor.clear.cgColor
            }
            
            // Allow scrolling in the UIScrollView until it reaches 350 pixels
            if scrollOffset > 350 {
                // Adjust the content offset of the UIScrollView to the maximum allowed offset
                myScrollView.contentOffset.y = 350

                // Notify the ShopPageViewController to enable scrolling in the UICollectionView
                pageViewController?.enableInnerCollectionViewScrolling()
            } else {
                // Reset the content offset of the inner UICollectionView when scrollOffset <= 350
                pageViewController?.resetInnerCollectionViewScrolling()
            }
        }
    }
    
    //changing bar button underlline
    func changebarButtonUnderLine(buttonNo : Int){
        currentPageTabViewLeftContraint.constant = 0 + ((screenWidth-20) / 4 * CGFloat(buttonNo))
    }
    
    //for changing page viewcontroller screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopPageViewController = segue.destination as? ShopPageViewController {
            self.pageViewController = shopPageViewController
            self.pageViewController?.pageDelegate = self
        }
    }
    func changePage(toIndex index: Int) {
            guard let pageViewController = self.pageViewController else {
                return
            }

            let direction: UIPageViewController.NavigationDirection = index > pageViewController.currentIndex ? .forward : .reverse

            pageViewController.setViewControllers([pageViewController.pageViewControllerList[index]], direction: direction, animated: true, completion: nil)
            pageViewController.currentIndex = index
        }
    func didChangePageIndex(index: Int) {
            // bar bottom line controll from these function , to update any thing in these view controller
        changebarButtonUnderLine(buttonNo: index)
    }
    
    func btnBackgroundShow(sender : UIView){
        sender.backgroundColor = .systemGray5
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
                sender.backgroundColor = .clear
            }, completion: nil)
    }

}
