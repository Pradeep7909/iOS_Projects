//
//  UpdateViewController.swift
//  Arfof Demo
//
//  Created by Guest on 11/23/23.
//

import UIKit
import PhotosUI

/// picker function check again beacuse of ios 13 i have made some changes..
class UpdateViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    var user : UserEntity?
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var ViewProfile: UIView!
    @IBOutlet weak var ViewField: UIView!
    @IBOutlet weak var Viewbtn: UIButton!
    @IBOutlet weak var profileEditBtn: UIImageView!
    
    var firstName : String = ""
    var lastName :  String = ""
    var email :  String = ""
    var number : String = ""
    var imageSelected = false
    
    private let manager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setField()
        // Do any additional setup after loading the view.
        configuration()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnUpdateData(_ sender: UIButton) {
        if(checkValidity()){
            if(imageSelected){
                let imageName = UUID().uuidString
                let updatedUser = UserModel(firstName: firstName, lastName: lastName, email: email, password: user?.password ?? "12345678", imageName: imageName, number: number)
                saveImageToDocumentDirectory(imageName: imageName)
                manager.updateUser(user: updatedUser, userEntity: user!)
            }else{
                let updatedUser = UserModel(firstName: firstName, lastName: lastName, email: email, password: user?.password ?? "12345678", imageName: (user?.imageName)!, number: number)
                manager.updateUser(user: updatedUser, userEntity: user!)
            }
            navigateToUserPage()
        }
    }
    
    //MARK: functions
    func checkValidity() -> Bool {
        hideErrorIcons()
        
        var isValid = true
        if (firstNameField.text?.isEmpty)! {
            showErrorIcon(for: firstNameField)
            isValid = false
        }else{
            firstName = firstNameField.text!
        }
        if (lastNameField.text?.isEmpty)! {
            showErrorIcon(for: lastNameField)
            isValid = false
        }else{
            lastName = lastNameField.text!
        }
        if (emailField.text?.isEmpty)! {
            showErrorIcon(for: emailField)
            isValid = false
        }else if (!isValidEmail(emailField.text!) ){
            showErrorIcon(for: emailField)
            isValid = false
        }
        else{
            email = emailField.text!
        }
        if(numberField.text?.isEmpty)!{
            showErrorIcon(for: numberField)
            isValid = false
        }else{
            number = numberField.text!
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
    func setField(){
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        numberField.delegate = self
        
        firstNameField.text = user?.firstName
        lastNameField.text = user?.lastName
        emailField.text = user?.email
        numberField.text = user?.number
        if(user?.imageName != "null"){
            let imageURL = URL.documentsDirectory.appendingPathComponent((user?.imageName)!).appendingPathExtension("png")
            profileImageView.image = UIImage(contentsOfFile: imageURL.path)
        }
        addErrorIconToTextFields()
    }
    
    func saveImageToDocumentDirectory(imageName : String){
        let fileURL = URL.documentsDirectory.appendingPathComponent(imageName).appendingPathExtension("png")
        if let data = profileImageView.image?.pngData(){
            do{
                try data.write(to: fileURL)
            }
            catch{
                print("Saving image to document error: " ,error)
            }
        }
    }
    @objc func openGallery(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
    }
    func configuration(){
        ViewProfile.layer.cornerRadius = 20
        ViewField.layer.cornerRadius = 20
        Viewbtn.layer.cornerRadius = 25
        profileEditBtn.layer.cornerRadius = 15
        
        addGesture()
        uiconfiguration()
    }
    func addGesture(){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(UpdateViewController.openGallery))
        profileEditBtn.addGestureRecognizer(imageTap)
    }
    func uiconfiguration(){
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }
    
    func addErrorIconToTextFields() {
        for textField in [firstNameField, lastNameField, emailField, numberField] {
            let errorImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
            errorImageView.tintColor = UIColor.red
            errorImageView.contentMode = .scaleAspectFit
            textField?.rightViewMode = .always
            textField?.rightView = errorImageView
        }
        hideErrorIcons()
    }

    func showErrorIcon(for textField: UITextField) {
        if let imageView = textField.rightView as? UIImageView {
            imageView.isHidden = false
        }
    }

    func hideErrorIcons() {
        for textField in [firstNameField, lastNameField, emailField, numberField] {
            if let imageView = textField?.rightView as? UIImageView {
                imageView.isHidden = true
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firstNameField {
            firstNameField.rightView?.isHidden = true
        } else if textField == lastNameField {
            lastNameField.rightView?.isHidden = true
        }else if textField == emailField {
            emailField.rightView?.isHidden = true
        }else if textField == numberField{
            numberField.rightView?.isHidden = true
        }
    }

}

