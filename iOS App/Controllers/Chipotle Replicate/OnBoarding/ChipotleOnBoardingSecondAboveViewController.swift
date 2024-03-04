//
//  ChipotleOnBoardingSecondAboveViewController.swift
//  iOS App
//
//  Created by Qualwebs on 21/02/24.
//

import UIKit


protocol OnBoardingSecondPageControllerDelegate: AnyObject {
//    func tabChangeController(_ tabPageViewController: ChipotleOnBoardingSecondPageViewController, didChangeTabToIndex index: Int)
//    func secondPageScrollViewController(_ tabPageViewController: ChipotleOnBoardingSecondPageViewController, didScrollToOffset offset: CGFloat)
    func moveToBelowPage()
}


class ChipotleOnBoardingSecondAboveViewController: UIViewController {
    
    static var delegate: OnBoardingSecondPageControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func orderButtonAction(_ sender: Any) {
        ChipotleOnBoardingSecondAboveViewController.delegate?.moveToBelowPage()
    }
}
