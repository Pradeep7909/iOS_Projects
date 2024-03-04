//
//  ChipotleMapViewController.swift
//  iOS App
//
//  Created by Qualwebs on 23/02/24.
//


import UIKit

class ChipotleMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardTappedAround()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelButtonAction(_ sender: Any) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
    

}
