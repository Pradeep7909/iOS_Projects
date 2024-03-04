//
//  ViewController.swift
//  iOS App
//
//  Created by Guest on 11/22/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    let validation = Validation()
    
    var email : String = ""
    var password :  String = ""
    
    var iconClick = true
    let imageicon = UIImageView()
    
    private var users: [UserEntity] = []
    private let manager = DatabaseManager()
    
    @IBOutlet var myscreen1: UIView!
    @IBOutlet weak var btnlogin: UIButton!
  
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblpassword: UILabel!
    @IBOutlet weak var screenViewScrollable: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnlogin.layer.cornerRadius = 10
        navigationItem.hidesBackButton = true
       
        emailField.delegate = self
        passwordField.delegate = self
        
        hidePasswordEye()
        hideKeyboardTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func btnForNavgiatetoSignUp(_ sender: UIButton) {
        navigateToSignUpPage()
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        clearlbl()
        if(validation.checkLoginValidation(email: emailField.text, emailWrongLbl: &lblemail.text, password: passwordField.text, passwordWrongLbl: &lblpassword.text)){
            email = emailField.text!
            password = passwordField.text!
            checkEmailPassword()
        }
    }
    
    //MARK: functions
    
    func checkEmailPassword(){
        users = manager.fetchUser()
        for user in users {
               if user.email == email{
                   if user.password == password{
                       navigateToUserPage()
                       return
                   }
                   else{
                       showAlert(message: "Password is incorrect")
                   }
                   return 
               }
           }
        showAlert(message: "Email is not Registered.")
    }
    
    func navigateToSignUpPage(){
        guard let navigationToPage = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            print(" not able to navigate")
            return
        }
        navigationController?.pushViewController(navigationToPage, animated: true)
        
    }
    func navigateToUserPage(){
        guard let navigationToPage = self.storyboard?.instantiateViewController(withIdentifier: "UserDataViewController") as? UserDataViewController else {
            print(" not able to navigate")
            return
        }
        navigationController?.pushViewController(navigationToPage, animated: true)
        
    }
    
    
    func clearlbl(){
        lblemail.text = nil
        lblpassword.text = nil
    }
      
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField {
            lblemail.text = nil // Clear the email error label
        } else if textField == passwordField {
            lblpassword.text = nil // Clear the password error label
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.emailField:
            self.passwordField.becomeFirstResponder()
        default:
            self.passwordField.resignFirstResponder()
        }
    }
    
    func hidePasswordEye(){
        imageicon.image = UIImage(systemName: "eye.slash.fill")
        imageicon.tintColor = .gray
        let contentView = UIView()
        contentView.addSubview(imageicon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        imageicon.frame = CGRect(x: -10, y: 0, width: 30, height: 20)
        passwordField.rightView = contentView
        passwordField.rightViewMode = .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer : )))
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer : UITapGestureRecognizer){
        let tappedimage = tapGestureRecognizer.view as! UIImageView
        
        if(iconClick){
            iconClick = false
            tappedimage.image = UIImage(systemName: "eye.fill")
            passwordField.isSecureTextEntry = false
        }
        else{
            iconClick = true
            tappedimage.image = UIImage(systemName: "eye.slash.fill")
            passwordField.isSecureTextEntry = true
            
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            screenViewScrollable.contentInset = contentInsets
            screenViewScrollable.scrollIndicatorInsets = contentInsets

            // Adjust the scroll view to show the active text field
            if let activeField = findActiveField() {
                let rect = screenViewScrollable.convert(activeField.frame, from: activeField.superview)
                screenViewScrollable.scrollRectToVisible(rect, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        screenViewScrollable.contentInset = contentInsets
        screenViewScrollable.scrollIndicatorInsets = contentInsets
    }

    // Helper function to find the active text field
    private func findActiveField() -> UITextField? {
        if emailField.isFirstResponder {
            return emailField
        } else if passwordField.isFirstResponder {
            return passwordField
        }
        return nil
    }

}
extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

