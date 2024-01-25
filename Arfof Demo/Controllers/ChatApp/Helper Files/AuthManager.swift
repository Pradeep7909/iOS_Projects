//
//  AuthManager.swift
//  Arfof Demo
//
//  Created by Guest on 12/26/23.
//

import Foundation
import FirebaseAuth

class AuthManager{
    static let shared = AuthManager()
    private let auth = Auth.auth()
    
    private var verificationId : String?
    
    public func startAuth(phoneNumber : String , completion: @escaping (Bool) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil){[weak self]verficationId, error in
            guard let verficationId = verficationId , error == nil else{
                completion(false)
                print("verfication failed")
                return
            }
            self?.verificationId = verficationId
            completion(true)
        }
    }
    public func verifyCode(smsCode  : String , completion: @escaping (Bool) -> Void){
        guard let verificationId = verificationId else{
            completion(false)
            print("No Verification id")
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: smsCode
        )
        auth.signIn(with: credential){result , error in
            
            guard result != nil, error == nil else{
                completion(false)
                print("result is null or there is error in signin")
                return
            }
        }
        completion(true)
    }
}

import Foundation

class CurrentUserManager {
    static let shared = CurrentUserManager()

    var currentUser: User?

    private init() {
        // Private initializer to ensure only one instance is created
    }
}


// for linkedin login
struct LinkedInConstants {
    static let CLIENT_ID = "77wanylp12fcbj"
    static let CLIENT_SECRET = "5wfmJVa4MwH4qgwU"
    static let REDIRECT_URI = "https://www.linkedin.com/developers/tools/oauth/redirect"
    static let SCOPE = "r_liteprofile%20r_emailaddress"
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}
