//
//  LoginValidation.swift
//  Arfof Demo
//
//  Created by Guest on 12/26/23.
//

import Foundation

class Validation{
    
    func checkLoginValidation(email: String?,  emailWrongLbl : inout String?, password:  String?, passwordWrongLbl: inout String?) -> Bool{
        var isValid = true
        if (email?.isEmpty)! {
            emailWrongLbl = "Enter your mail."
            print( "Enter your mail.")
            isValid = false
        }else if(!isValidEmail(email!) ){
            emailWrongLbl = "Invalid Email Address."
            print("Invalid Email Address.")
            isValid = false
        }else{
            print("Email taken")
        }
        
        if (password?.isEmpty)! {
            passwordWrongLbl = "Enter you password."
            print("Invalid Email Address.")
            isValid = false
        }
        else{
            print("Password taken")
        }
        if(isValid){
            print("Both email and password are valid")
        }
        else{
            print("Not valid email or password")
        }
        return isValid
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    
}
