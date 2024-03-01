//
//  MainViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/16/23.
//

import UIKit
import FirebaseInAppMessaging

class MainViewController: UIViewController,TabPageViewControllerDelegate {
   
    var currentIndex: Int = 0
    let cardActionDelegate = CardActionFiamDelegate()
    
    //MARK: - Outlets
    @IBOutlet weak var homeTabView: UIView!
    @IBOutlet weak var exploreTabView: UIView!
    @IBOutlet weak var ordersTabView: UIView!
    @IBOutlet weak var profileTabView: UIView!
    @IBOutlet weak var searchTabView: CustomView!
    
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var exploreImage: UIImageView!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var exploreScreenBackground: UIView!
    @IBOutlet weak var backExploreButton: UIView!
    @IBOutlet weak var backAccessoriesView: CustomView!
    @IBOutlet weak var backFoodView: CustomView!
    @IBOutlet weak var backExploreContraints: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestures()
        homeImage.tintColor = UIColor(hex: 0x713C75)
        homeLabel.textColor = UIColor(hex: 0x713C75)
        
        // for in app message navigation, assinging a view controlller to it..
        cardActionDelegate.viewController = self
        InAppMessaging.inAppMessaging().delegate = cardActionDelegate
        
        
//        if let tabPageViewController = self.children.first as? TabPageViewController {
//            tabPageViewController.tabDelegate = self
//        }
    }
    
    //MARK: - functions
    func addGestures(){
        let homeTapGesture = UITapGestureRecognizer(target: self, action: #selector(homeTapped))
        homeTabView.addGestureRecognizer(homeTapGesture)
        
        let exploreTapGesture = UITapGestureRecognizer(target: self, action: #selector(exploreTapped))
        exploreTabView.addGestureRecognizer(exploreTapGesture)
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        searchTabView.addGestureRecognizer(searchTapGesture)
        
        let orderTapGesture = UITapGestureRecognizer(target: self, action: #selector(orderTapped))
        ordersTabView.addGestureRecognizer(orderTapGesture)
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileTabView.addGestureRecognizer(profileTapGesture)

        // gestures for background of explore screen
        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        exploreScreenBackground.addGestureRecognizer(backgroundGesture)
        
        let foodViewGesture = UITapGestureRecognizer(target: self, action: #selector(moveToExploreScreen))
        backFoodView.addGestureRecognizer(foodViewGesture)
        
        let AccessoriesViewGesture = UITapGestureRecognizer(target: self, action: #selector(moveToExploreScreen))
        backAccessoriesView.addGestureRecognizer(AccessoriesViewGesture)
    }
    @objc func homeTapped(){
        switchToTab(index: 0)
        clearTabColor()
        setColor(image: homeImage, label: homeLabel)
    }
    @objc func exploreTapped(){
        bringBackground()
    }
    @objc func searchTapped(){
        switchToTab(index: 2)
        clearTabColor()
    }
    @objc func orderTapped(){
        switchToTab(index: 3)
        clearTabColor()
        setColor(image: orderImage, label: orderLabel)
    }
    @objc func profileTapped(){
        switchToTab(index: 4)
        clearTabColor()
        setColor(image: profileImage, label: profileLabel)
    }
    @objc func backgroundTapped(){
        sendBackground()
    }
    @objc func moveToExploreScreen(){
        switchToTab(index: 1)
        clearTabColor()
        setColor(image: exploreImage, label: exploreLabel)
        sendBackground()
    }
    
    
    
    // for updating in pageviewcontroller
    func tabPageViewController(_ tabPageViewController: TabPageViewController, didChangeTabToIndex index: Int) {
        currentIndex = index
        // if want to change in main screen can perfrom here...
    }
    
    //fucntion for switching tabs
    func switchToTab(index: Int) {
        guard let tabPageViewController = self.children.first as? TabPageViewController,
                index >= 0 && index < tabPageViewController.pageViewControllerList.count else {
               return
        }
        tabPageViewController.setViewControllers([tabPageViewController.pageViewControllerList[index]], direction: .forward, animated: false, completion: nil)
        tabPageViewController.tabDelegate?.tabPageViewController(tabPageViewController, didChangeTabToIndex: index)
    }
    // set tab image and label black
    func clearTabColor(){
        homeImage.tintColor = UIColor(hex: 0x333333)
        homeLabel.textColor = UIColor(hex: 0x333333)
        exploreImage.tintColor = UIColor(hex: 0x333333)
        exploreLabel.textColor = UIColor(hex: 0x333333)
        orderImage.tintColor = UIColor(hex: 0x333333)
        orderLabel.textColor = UIColor(hex: 0x333333)
        profileImage.tintColor = UIColor(hex: 0x333333)
        profileLabel.textColor = UIColor(hex: 0x333333)
    }
    //set color of current tab
    func setColor(image: UIImageView , label: UILabel){
        image.tintColor = UIColor(hex: 0x713C75)
        label.textColor = UIColor(hex: 0x713C75)
    }
    
    //Bring background of explore screen front
    func bringBackground(){
        self.exploreScreenBackground.superview?.bringSubviewToFront(self.exploreScreenBackground)
        self.backExploreButton.superview?.bringSubviewToFront(self.backExploreButton)
        UIView.animate(withDuration: 0.3) {
            self.exploreScreenBackground.alpha = 0.8
            self.backExploreContraints.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    func sendBackground(){
        UIView.animate(withDuration: 0.3, animations: {
            self.exploreScreenBackground.alpha = 0
            self.backExploreContraints.constant = -200
            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.exploreScreenBackground.superview?.sendSubviewToBack(self.exploreScreenBackground)
                self.backExploreButton.superview?.sendSubviewToBack(self.backExploreButton)
            })
    }
}


//for specific color
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
extension UIViewController{
    // getting exact time from timestamp
    func formattedTimeFromTimestamp(_ timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm" //format as needed
        return dateFormatter.string(from: date)
    }
    
    func showToast(message: String, backgroundColor: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-50, width: 300, height: 35))
        toastLabel.backgroundColor = backgroundColor
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}
