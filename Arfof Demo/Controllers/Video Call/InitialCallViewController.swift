//
//  InitialCallViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 24/02/24.
//

import UIKit
import Firebase

class InitialCallViewController: UIViewController {

    var user : Int = 0
    
    @IBOutlet weak var tomView: CustomViewShadow!
    @IBOutlet weak var jerryView: CustomViewShadow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkUserLoggedIn()
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if user != 0{
            UserDefaults.standard.set(user, forKey: "userId")
            ToastManager.shared.showToast(message: "Logged In", backgroundColor: .green, backgroundOpacity: 0.2)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallHomeViewController") as! VideoCallHomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            ToastManager.shared.showToast(message: "Please select a user", backgroundColor: .red, backgroundOpacity: 0.2)
        }
    }
    
    @IBAction func tomButtonAction(_ sender: Any) {
        user = 1
        setColor()
    }
    
    
    @IBAction func jerryButtonAction(_ sender: Any) {
        user = 2
        setColor()
    }
    
    private func setColor(){
        tomView.backgroundColor = user == 1 ? K_LIGHT_BLUE_COLOR : K_DARK_BLUE_COLOR
        jerryView.backgroundColor = user == 2 ? K_LIGHT_BLUE_COLOR : K_DARK_BLUE_COLOR
    }

    private func checkUserLoggedIn() {
        if UserDefaults.standard.value(forKey: "userId") is Int {
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "VideoCallHomeViewController") as! VideoCallHomeViewController
            navigationController?.pushViewController(homeVC, animated: false)
        }
    }
}
