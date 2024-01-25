//
//  PhoneViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/26/23.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import WebKit

class PhoneViewController: UIViewController , UITextFieldDelegate, WKNavigationDelegate {
    
    //MARK: Variables
    let loginManager = LoginManager()
    
    var number: String = ""
    var webView = WKWebView()
    let twitterProvider = OAuthProvider(providerID: "twitter.com")
    var githubProvider = OAuthProvider(providerID: "github.com")
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var validationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking user authorized or not
        checkUserLoggedIn()
        
        
        phoneNumberTextField.delegate = self
        validationLabel.text = nil
        validationImage.isHidden = true
        hideKeyboardTappedAround()
        // just trying
        loginManager.logOut()
    }
    
    //MARK: Outlet Actions
    
    // for phone number
    @IBAction func proceedActionButton(_ sender: Any) {
        if(checkValidation()){
            number = phoneNumberTextField.text!
            print("number is \(number)")
            let codeNumber = "+91" + number
            
            AuthManager.shared.startAuth(phoneNumber: codeNumber) { [weak self]success in
                guard success else { return }
                DispatchQueue.main.async {
                    let controller = self?.storyboard?.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
                    controller.receivedPhoneNumber = self?.number
                    self?.navigationController?.pushViewController(controller, animated: true)
                    print("Navigated to OTP Screen")
                }
            }
        }
    }
    
    // for facebook
    @IBAction func fbLoginButtonAction(_ sender: Any) {
        facebookLogout()
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Facebook login error: \(error.localizedDescription)")
            } else if let result = result, !result.isCancelled {
                // Facebook login successful, you can handle the result here
                self.fetchFacebookUserProfile()
                
                print("Navigate to Account Page")
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                controller.accountHeaderLabel = "Logged in using Facbook"
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
    }
    
    // it only logout i want that user can login with new email and password..
    // Function to perform Facebook logout
    func facebookLogout() {
        loginManager.logOut()
        print("old facebook user data has been cleared ")
    }
    
    // for google
    @IBAction func googleLoginButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                // Handle sign-in error
                print("Google Sign-In error: \(error!.localizedDescription)")
                return
            }
            
            if let user = GIDSignIn.sharedInstance.currentUser {
                let userId = user.userID
                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                let email = user.profile?.email
                
                // Print user info..
                print("User ID: \(userId ?? "")")
                print("Full Name: \(fullName ?? "")")
                print("Given Name: \(givenName ?? "")")
                print("Family Name: \(familyName ?? "")")
                print("Email: \(email ?? "")")
                
                // Navigate to the Account screen
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                
                controller.accountHeaderLabel = "Logged in using Google"
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // for github
    @IBAction func githubLoginButtonAction(_ sender: Any) {
        
        githubProvider.getCredentialWith(nil) { credential, error in
            
            if error != nil {
                // Handle error.
            }
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        // Handle error.
                    }
                    print("Login succesful")
                    
                    guard let oauthCredential = authResult?.credential as? OAuthCredential else { return }
                    print(oauthCredential.idToken!)
                    // Navigate to the Account screen
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    controller.accountHeaderLabel = "Logged in using Twitter"
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    // for twitter
    @IBAction func twitterLoginButtonAction(_ sender: Any) {
        
        revokeTwitterToken()
        // Get the OAuth credential
        twitterProvider.getCredentialWith(nil) { credential, error in
            
            if let error = error {
                print("Error getting Twitter credential: \(error.localizedDescription)")
            } else if let credential = credential {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase authentication error: \(error.localizedDescription)")
                    } else if let _ = authResult {
                        print("Firebase authentication successful")
                        
                        // Navigate to the Account screen
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        
                        controller.accountHeaderLabel = "Logged in using Twitter"
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        }
    }
    
    // Function to revoke the Twitter access token
    func revokeTwitterToken() {
        
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        
        if let user = Auth.auth().currentUser {
            user.unlink(fromProvider: "twitter.com") { _, error in
                if let error = error {
                    print("Error unlinking Twitter account: \(error.localizedDescription)")
                } else {
                    print("Twitter account unlinked successfully")
                }
            }
        }
    }
    
    @IBAction func linkedinLoginButtonAction(_ sender: Any) {
        print("Linkedin Button Tapped")
        linkedInAuthVC()
    }
    
    
    
    
    //MARK: Functions
    
    func checkValidation() -> Bool{
        if(phoneNumberTextField.text?.count == 0){
            print("Enter Mobile Number")
            validationLabel.text = "Please, Enter your phone number"
            validationImage.isHidden =  false
            return false
        }else if(phoneNumberTextField.text?.count != 10){
            print("Enter a Valid Number")
            validationLabel.text = "Please, Enter correct phone number"
            validationImage.isHidden =  false
            // I am not checking its valid number or not for now...
            return false
        }else if !phoneNumberTextField.text!.isNumeric {
            print("Phone number should contain only digits")
            validationLabel.text = "Please, Enter a valid phone number with only digits"
            validationImage.isHidden =  false
            return false
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        validationLabel.text = nil
        validationImage.isHidden = true
    }
    
    
    func fetchFacebookUserProfile() {
        guard let token = AccessToken.current?.tokenString else {
            return
        }
        
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "name, email"], tokenString: token, version: nil, httpMethod: .get)
        request.start { _, result, error in
            if let error = error {
                print("Facebook user profile request error: \(error.localizedDescription)")
            } else if let result = result as? [String: Any] {
                print("Facebook user profile: \(result)")
                // Handle user profile data as needed
            }
        }
    }
    
    
    
    
    // for linkedin login using webkit
    func linkedInAuthVC() {
        // Create LinkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
        ])
        
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    
    //MARK: Userlogged in checking
    func checkUserLoggedIn(){
        if Auth.auth().currentUser != nil {
            // User is authenticated, show the WelcomeViewController
            print("User is Already Logged in")
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            // User is not authenticated, show the AuthenticationViewController
            print("User is Not logged in")
        }
    }
}

// for checking string contain only digits
extension String {
    var isNumeric: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
}
