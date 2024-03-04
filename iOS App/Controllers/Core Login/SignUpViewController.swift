//
//  SignUpViewController.swift
//  iOS App
//
//  Created by Guest on 11/22/23.
//

import UIKit

class SignUpViewController: UIViewController , UITextFieldDelegate{

    
    @IBOutlet var myscreen2: UIView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cpasswordField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblcPassword: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var screenViewScrollable: UIScrollView!
    
    
    var firstName : String = ""
    var lastName :  String = ""
    var email :  String = ""
    var password : String = ""
    var number : String = ""
    
    var iconClick1 = true
    let imageicon1 = UIImageView()
    var iconClick2 = true
    let imageicon2 = UIImageView()
    private var users: [UserEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        numberField.keyboardType = .numberPad
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        numberField.delegate = self
        passwordField.delegate = self
        cpasswordField.delegate = self
        
        hidePasswordEye1()
        hidePasswordEye2()

        self.hideKeyboardTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                
    }
    
    
    @IBAction func btnNavigatetoLogin(_ sender: UIButton) {
        navigateToLoginPage()
    }
    
    
    //MARK: functions
    
    func navigateToLoginPage(){
        guard let navigationToPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            print(" not able to navigate")
            return
        }
        navigationController?.pushViewController(navigationToPage, animated: true)
    }
 

    
    private let manager = DatabaseManager()
    
    
    @IBAction func btnSignup(_ sender: UIButton) {
        
        clearlbl()
        if(checkValidity()){
            if(checkEmailPassword()){
                let user = UserModel(firstName: firstName, lastName: lastName, email: email, password: password, imageName: "null", number: number)
                manager.addUser(user)
                
                navigateToUserPage()
            }
        }
    }
    
    func checkEmailPassword()-> Bool{
        users = manager.fetchUser()
        for user in users {
               if user.email == email{
                   showAlert(message: "Email is Already Registered.")
                   return false
               }
           }
        return true
    }
    
    func checkValidity() -> Bool {
        var isValid = true
        if (firstNameField.text?.isEmpty)! {
            lblFirstName.text = "Enter your First Name."
            isValid = false
        }else{
            firstName = firstNameField.text!
        }
        if (lastNameField.text?.isEmpty)! {
            lblLastName.text = "Enter your Last Name."
            isValid = false
        }else{
            lastName = lastNameField.text!
        }
        if (emailField.text?.isEmpty)! {
            lblEmail.text = "Enter your Email."
            isValid = false
        }else if (!isValidEmail(emailField.text!) ){
            lblEmail.text = "Invalid Email Address."
            isValid = false
        }
        else{
            email = emailField.text!
        }
        if(numberField.text?.isEmpty)!{
            lblNumber.text = "Enter you number"
            isValid = false
        }else if (!isValidNumber(numberField.text!)){
            lblNumber.text = "Invalid number"
            isValid = false
        }
        else{
            number = numberField.text!
        }
        if(passwordField.text?.isEmpty)! {
            lblPassword.text = "Enter your Password."
            isValid = false
        }
        else{
            password = passwordField.text!
        }
        if(cpasswordField.text?.isEmpty)! {
            lblcPassword.text = "Confirm your Password."
            isValid = false
        }
        else if (passwordField.text != cpasswordField.text){
            lblcPassword.text = "Enter Same Password."
            isValid = false
        }
        
        
        return isValid
    }
    func clearlbl(){
        lblFirstName.text = nil
        lblLastName.text = nil
        lblEmail.text = nil
        lblPassword.text = nil
        lblNumber.text = nil
    }
    func isValidNumber(_ number : String) -> Bool{
        var isValid = true
        if(number.count != 10){
            isValid = false
        }else {
            for char in number {
                if let _ = Int(String(char)) {
                    // The character is an integer
                } else {
                    isValid = false
                    break
                }
            }
        }
        return isValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    func navigateToUserPage(){
        guard let navigationToPage = self.storyboard?.instantiateViewController(withIdentifier: "UserDataViewController") as? UserDataViewController else {
            print(" not able to navigate")
            return
        }
        navigationController?.pushViewController(navigationToPage, animated: true)
        
    }
    
    
    func hidePasswordEye1(){
        imageicon1.image = UIImage(systemName: "eye.slash.fill")
        imageicon1.tintColor = .gray
        passwordField.isSecureTextEntry = true
        let contentView = UIView()
        contentView.addSubview(imageicon1)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        imageicon1.frame = CGRect(x: -10, y: 0, width: 30, height: 20)
        passwordField.rightView = contentView
        passwordField.rightViewMode = .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer : )))
        imageicon1.isUserInteractionEnabled = true
        imageicon1.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped1(tapGestureRecognizer : UITapGestureRecognizer){
        let tappedimage = tapGestureRecognizer.view as! UIImageView
        
        if(iconClick1){
            iconClick1 = false
            tappedimage.image = UIImage(systemName: "eye.fill")
            passwordField.isSecureTextEntry = false
        }
        else{
            iconClick1 = true
            tappedimage.image = UIImage(systemName: "eye.slash.fill")
            passwordField.isSecureTextEntry = true
            
        }
    }
    func hidePasswordEye2(){
        imageicon2.image = UIImage(systemName: "eye.slash.fill")
        imageicon2.tintColor = .gray
        cpasswordField.isSecureTextEntry = true
        let contentView = UIView()
        contentView.addSubview(imageicon2)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        imageicon2.frame = CGRect(x: -10, y: 0, width: 30, height: 20)
        cpasswordField.rightView = contentView
        cpasswordField.rightViewMode = .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer : )))
        imageicon2.isUserInteractionEnabled = true
        imageicon2.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped2(tapGestureRecognizer : UITapGestureRecognizer){
        let tappedimage = tapGestureRecognizer.view as! UIImageView
        
        if(iconClick2){
            iconClick2 = false
            tappedimage.image = UIImage(systemName: "eye.fill")
            cpasswordField.isSecureTextEntry = false
        }
        else{
            iconClick2 = true
            tappedimage.image = UIImage(systemName: "eye.slash.fill")
            cpasswordField.isSecureTextEntry = true
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firstNameField {
            lblFirstName.text = nil
        } else if textField == lastNameField {
            lblLastName.text = nil
        }else if textField == emailField {
            lblEmail.text = nil
        }else if textField == numberField{
            lblNumber.text = nil
        }else if textField == passwordField {
            lblPassword.text = nil
        }
        else if textField == cpasswordField {
            lblcPassword.text = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.firstNameField:
            self.lastNameField.becomeFirstResponder()
        case self.lastNameField:
            self.emailField.becomeFirstResponder()
        case self.emailField:
            self.numberField.becomeFirstResponder()
        case self.numberField:
            self.passwordField.becomeFirstResponder()
        case self.passwordField:
            self.cpasswordField.becomeFirstResponder()
        default:
            self.cpasswordField.resignFirstResponder()
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
        if firstNameField.isFirstResponder {
            return firstNameField
        } else if lastNameField.isFirstResponder {
            return lastNameField
        } else if emailField.isFirstResponder {
            return emailField
        }else if numberField.isFirstResponder {
            return numberField
        }else if passwordField.isFirstResponder {
            return passwordField
        } else if cpasswordField.isFirstResponder {
            return cpasswordField
        }
        return nil
    }

}

extension UIViewController{
    func hideKeyboardTappedAround(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
