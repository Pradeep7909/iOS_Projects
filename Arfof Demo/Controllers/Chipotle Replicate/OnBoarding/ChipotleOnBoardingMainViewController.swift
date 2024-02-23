//
//  File.swift
//  Arfof Demo
//
//  Created by Qualwebs on 23/02/24.
//


import UIKit
import LocalAuthentication

protocol ChipotleOnBoardingMainViewControllerDelegate: AnyObject {
    func moveToCenterScreen(index : Int)
}

class ChipotleOnBoardingMainViewController: UIViewController{
    
    var currentPage = 1
    var secondCurrentPage = 1
    var screenWidth : CGFloat = 400
    var screenHeight : CGFloat = 700
    static var delegate: ChipotleOnBoardingMainViewControllerDelegate?
    let context = LAContext()
    
    
    //MARK: Outlets
    @IBOutlet weak var leadingSpaceTopView: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintBottomView: NSLayoutConstraint!
    @IBOutlet weak var profileTopImage: UIImageView!
    @IBOutlet weak var bagTopImage: UIImageView!
    @IBOutlet weak var overlayProfileImage: UIImageView!
    @IBOutlet weak var overlayBagImage: UIImageView!
    @IBOutlet weak var leadingContraintImageView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintImageView: NSLayoutConstraint!
    @IBOutlet weak var topChevronImage: UIImageView!
    @IBOutlet weak var chevronButton: UIButton!
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        ChipotleOnBoardingSecondPageViewController.tabDelegate = self
        topChevronImage.alpha = 0
        chevronButton.isHidden = true
        overlayProfileImage.alpha = -1
        overlayBagImage.alpha = -0.5
        
        //MARK: Biometric Auth
        beginIdentity()
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? ChipotleOnBoardingPageViewController {
            pageViewController.tabDelegate = self
        }
    }
    
    
    //MARK: IBAction
    @IBAction func menuButtonAction(_ sender: Any) {
        navigateToBottomTab(currentIndex: 0)
    }
    
    @IBAction func featureButtonAction(_ sender: Any) {
        navigateToBottomTab(currentIndex: 1)
    }
    
    @IBAction func orderButtonAction(_ sender: Any) {
        navigateToBottomTab(currentIndex: 2)
    }
    
    @IBAction func rewardButtonAction(_ sender: Any) {
        navigateToBottomTab(currentIndex: 3)
    }
    
    @IBAction func chevronButtonAction(_ sender: Any) {
        ChipotleOnBoardingMainViewController.delegate?.moveToCenterScreen(index: 1)
    }
    
    
    @IBAction func personButtonAction(_ sender: Any) {
        ChipotleOnBoardingMainViewController.delegate?.moveToCenterScreen(index: 0)
    }
    
    
    @IBAction func bagButtonAction(_ sender: Any) {
        ChipotleOnBoardingMainViewController.delegate?.moveToCenterScreen(index: 2)
    }
    
    
    //MARK: Functions
    // going to bottom tabs screen
    func navigateToBottomTab(currentIndex : Int ){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomTabViewController") as! BottomTabViewController
        vc.currentIndex = currentIndex
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}



//MARK: Horizontal PageViewControllerDelegate
extension ChipotleOnBoardingMainViewController : ChipotleOnBoardingPageViewControllerDelegate {
    
    func tabPageViewController(_ tabPageViewController: ChipotleOnBoardingPageViewController, didChangeTabToIndex index: Int) {
        currentPage = index
        chevronButton.isHidden = currentPage == 1 ? true : false
        if currentPage == 1{
            leadingSpaceTopView.constant = 0
        }else if currentPage == 0{
            leadingSpaceTopView.constant = (screenWidth / 2 - 25 )
        }else{
            leadingSpaceTopView.constant = -(screenWidth / 2 - 25 )
        }
    }
    
    func pageScrollViewController(_ tabPageViewController: ChipotleOnBoardingPageViewController, didScrollToOffset offset: CGFloat) {
        
        let change = screenWidth - offset // calculating offset because right now getting screenwidth + offset
        let changeinTopView =  ((screenWidth / 2 - 25 ) / screenWidth ) * change // change in topview for sliding
        let changeinImageView = ((screenWidth / 4) / screenWidth ) * change
        let changeinBottomView = abs( 100 / screenWidth * change)
        let changeinAlpha = (100 / screenWidth * change) / 100
        
        if currentPage == 1{
            if changeinTopView != 0{
                leadingSpaceTopView.constant = changeinTopView
                leadingContraintImageView.constant = changeinImageView
                bottomContraintBottomView.constant = secondCurrentPage == 1 ? -changeinBottomView : -100
                topChevronImage.alpha = abs(changeinAlpha)
//                overlayProfileImage.alpha = abs(changeinAlpha)
//                overlayBagImage.alpha = abs(changeinAlpha)
                topChevronImage.image = changeinAlpha > 0 ? UIImage(systemName: "chevron.right") : UIImage(systemName: "chevron.left")
               
            }
        }
        else if currentPage == 0{
            if changeinTopView != 0{
                leadingSpaceTopView.constant = (screenWidth / 2 - 25 ) + changeinTopView
                leadingContraintImageView.constant = (screenWidth / 4) + changeinImageView
                bottomContraintBottomView.constant = secondCurrentPage == 1 ?  changeinBottomView - 100 : -100
                topChevronImage.alpha = 1 + changeinAlpha
                overlayProfileImage.alpha = 1 + changeinAlpha
                overlayBagImage.alpha = 1 + changeinAlpha
                if profileTopImage.image != UIImage(systemName: "person"){
                    changeImageWithAnimation(imageView: profileTopImage, newImageName: "person")
                }
            }else{
                changeImageWithAnimation(imageView: profileTopImage, newImageName: "person.fill")
            }
        }
        else{
            if changeinTopView != 0{
                leadingSpaceTopView.constant = changeinTopView - (screenWidth / 2 - 25 )
                leadingContraintImageView.constant = changeinImageView - (screenWidth / 4)
                bottomContraintBottomView.constant = secondCurrentPage == 1 ?  changeinBottomView - 100 : -100
                topChevronImage.alpha = 1 - changeinAlpha
                overlayBagImage.alpha = 1 - changeinAlpha
                overlayProfileImage.alpha = 1 - changeinAlpha
                if bagTopImage.image != UIImage(systemName: "bag"){
                    changeImageWithAnimation(imageView: bagTopImage, newImageName: "bag")
                }
                
            }
            else{
                changeImageWithAnimation(imageView: bagTopImage, newImageName: "bag.fill")
            }
        }
    }
    
    
    func changeImageWithAnimation(imageView: UIImageView, newImageName: String) {
        UIView.transition(with: imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            imageView.image = UIImage(systemName: newImageName)
        },
                          completion: nil)
    }
}


//MARK: Vertical PageViewControllerDelegate
extension ChipotleOnBoardingMainViewController : ChipotleOnBoardingSecondPageViewControllerDelegate {
    
    func tabChangeController(_ tabPageViewController: ChipotleOnBoardingSecondPageViewController, didChangeTabToIndex index: Int) {
        secondCurrentPage = index
    }
    
    func secondPageScrollViewController(_ tabPageViewController: ChipotleOnBoardingSecondPageViewController, didScrollToOffset offset: CGFloat) {
        let change = screenHeight - offset
        let changeinImageView = ((screenHeight / 4) / screenHeight ) * change
        let changeinBottomView = abs( 100 / screenHeight * change)
        
        
        if secondCurrentPage == 1{
            bottomContraintBottomView.constant = -changeinBottomView
            topConstraintImageView.constant = changeinImageView
        }else{
            bottomContraintBottomView.constant =  changeinBottomView - 100
            topConstraintImageView.constant = change != 0 ? (screenHeight / 4) +  changeinImageView : 0
        }
    }
}

//MARK: Biometric Auth
extension ChipotleOnBoardingMainViewController {
    
    //biometric auth
    func beginIdentity(){
        var error : NSError?
        guard self.context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else{
            print(error!)
            return
        }
        
        context.localizedFallbackTitle = "Enter PIN"
        
        if self.context.biometryType == .faceID{
            print("faceid")
        }else if self.context.biometryType == .touchID{
            print("touch id")
        }else{
            print("biometric is not supported")
        }
        authenticate()
    }
    
    func authenticate() {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your account") { success, error in
            DispatchQueue.main.async {
                if success {
                    // Biometric or PIN authentication successful
                    print("Authentication successful")
                } else {
                    if let error = error {
                        print("Authentication failed: \(error.localizedDescription)")
                    } else {
                        print("Authentication canceled")
                    }
                    self.showAuthenticationAlert()
                }
            }
        }
    }
    
    
    func showAuthenticationAlert() {
        let alert = UIAlertController(title: "Authentication Required",
                                      message: "Authentication is required to access data.",
                                      preferredStyle: .alert)
        
        let unlockAction = UIAlertAction(title: "Unlock Now", style: .default) { _ in
            self.authenticate()
        }
        
        alert.addAction(unlockAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

