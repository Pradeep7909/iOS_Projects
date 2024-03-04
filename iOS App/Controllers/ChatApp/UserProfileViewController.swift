//
//  UserProfileViewController.swift
//  iOS App
//
//  Created by Qualwebs on 09/01/24.
//

import UIKit
import Firebase
import PhotosUI
import SDWebImage
import FirebaseAnalytics

class UserProfileViewController: UIViewController, UITextFieldDelegate {
    
    var backbtnHide = true
    var userprofileImageURL : URL?
    var userNameData : String?
    var userAboutData :String = "Hey! I am using MyChat."
    
    
    //MARK: IBOutlet
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameWrongLabel: UIImageView!
    @IBOutlet weak var userAboutTextView: UITextView!
    @IBOutlet weak var backbtnView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameWrongLabel.isHidden = true
        hideKeyboardTappedAround()
        setUserProfileData()
    }
   
    
    //MARK: IBOutlet Actions
    @IBAction func userDataSaveButton(_ sender: Any) {
        ActivityIndicator.show(view: self.view)
        guard let username = nameTextField.text else {return}
        guard let image = userProfile.image else {return}
        guard let aboutUser = userAboutTextView.text else{return}
        
        if(checkValidity()){
            // Upload the image to Firebase Storage
            uploadImage(image) { url in
                print("uploading data")
                if let imageURL = url {
                    // If the image upload is successful, save the username and image URL to Realtime Database
                    self.saveUserDataToRealtimeDatabase(username: username, aboutUser: aboutUser, profileImageURL: imageURL)
                    // Navigate to HomeViewController
                    DispatchQueue.main.async{
                        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else{return}
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    print("Error uploading image to Firebase Storage")
                }
                ActivityIndicator.hide()
            }
        }else{
            ActivityIndicator.hide()
        }
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        showImagePickerOptions()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            Analytics.logEvent("user_logout", parameters: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneViewController") as! PhoneViewController
            self.navigationController?.pushViewController(vc, animated: false)
            
        } catch let error as NSError {
            print("Error signing out: \(error.localizedDescription)")
            
        }
    }
    
    
    //MARK: Functions
    
    func setUserProfileData(){
        backbtnView.isHidden = backbtnHide
        userAboutTextView.layer.borderColor = UIColor.lightGray.cgColor
        userAboutTextView.layer.borderWidth = 1
        guard userNameData != nil else{
            print("New user")
            userNameLabel.text = ""
            return
        }
        userProfile.sd_setImage(with: userprofileImageURL, placeholderImage: UIImage(systemName: "person.circle"))
        nameTextField.text = userNameData
        userAboutTextView.text = userAboutData
        userNameLabel.text = userNameData
    }
    
    
    // profile image selceting function
    func showImagePickerOptions(){
        let alertVC = UIAlertController(title: "Pick a photo", message: "Choose a picture from library or camera", preferredStyle: .actionSheet)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                let cameraImagePicker = self.imagePicker(sourceType: .camera)
                cameraImagePicker.delegate = self
                self.present(cameraImagePicker, animated: true)
            }
            alertVC.addAction(cameraAction)
        }else{
            print("Camera is not avaiable..")
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { action in
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.allowsEditing = true
            libraryImagePicker.delegate = self
            
            self.present(libraryImagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func checkValidity() -> Bool{
        if (nameTextField.text?.isEmpty)! {
            print("User Name is empty..")
            nameWrongLabel.isHidden = false
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameWrongLabel.isHidden = true
    }
    
    // Function to upload image to Firebase Storage
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> Void) {
        // Initialize Firebase Storage reference
        let storageRef = Storage.storage().reference()
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let imageFileName = "\(Auth.auth().currentUser!.uid)_profile_image.jpg"
        let profileImageRef = storageRef.child("profile_images/\(imageFileName)")
        
        // Upload the file to the path "profile_images/{imageFileName}"
        let uploadTask = profileImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image: \(String(describing: error))")
                completion(nil)
                return
            }
            
            // You can access the download URL of the image
            profileImageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(String(describing: error))")
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
    }
    
    //save user detail in firebase..
    func saveUserDataToRealtimeDatabase(username: String, aboutUser:String, profileImageURL: URL?) {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            
            let databaseRef = Database.database().reference().child("users").child(uid)
            databaseRef.child("username").setValue(username)
            databaseRef.child("aboutUser").setValue(aboutUser)
            databaseRef.child("isOnline").setValue(true)
            
            if let imageURL = profileImageURL {
                databaseRef.child("profileImageURL").setValue(imageURL.absoluteString)
            }
            print("User Data saved...")
        } else {
            // Handle the case where the user is not authenticated
            print("user Data not saved...")
        }
    }
    
}

//MARK: Extension imagepicker
extension UserProfileViewController : UIImagePickerControllerDelegate ,  UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        self.userProfile.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
