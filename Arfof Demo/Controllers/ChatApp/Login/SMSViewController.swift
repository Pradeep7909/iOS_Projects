//
//  SMSViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/26/23.
//

import UIKit
import FirebaseAnalytics

class SMSViewController: UIViewController , UITextFieldDelegate {
    
    var otpCode : String = ""
    var receivedPhoneNumber: String?
    
    @IBOutlet weak var verficationNumberLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var validationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.delegate = self
        verficationNumberLabel.text = verficationNumberLabel.text! + "+91 \(receivedPhoneNumber ?? "*********")"
        hideKeyboardTappedAround()
        validationLabel.text = nil
        validationImage.isHidden = true
    }
    
    @IBAction func verifyActionButton(_ sender: Any) {
        if(otpTextField.text?.count != 6){
            validationLabel.text = "Please, Enter correct OTP"
            validationImage.isHidden =  false
            print("Enter Correct OTP")
        }
        else if(!otpTextField.text!.isNumeric){
            validationLabel.text = "Please, Enter correct OTP with only digits"
            validationImage.isHidden =  false
            print("Enter only digit")
        }
        else{
            otpCode = otpTextField.text!
            print("OTP: \(otpCode)")
            AuthManager.shared.verifyCode(smsCode: otpCode) { [weak self] success in
                guard success else{ return }
                DispatchQueue.main.async {
                    let controller = self?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    controller.accountHeaderLabel = "Logged in using Phone Number"
                    self?.navigationController?.pushViewController(controller, animated: true)
                    Analytics.logEvent("user_login", parameters: nil)
                    print("Navigated to Main Account Screen")
                }
            }
            
        }
    }
    
    @IBAction func numberChangeActionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        print("back to Phone Number Screen")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        validationLabel.text = nil
        validationImage.isHidden = true
    }
    
}
