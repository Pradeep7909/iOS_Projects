//
//  LoginValidation.swift
//  Arfof DemoTests
//
//  Created by Guest on 12/26/23.
//

import XCTest
@testable import Arfof_Demo

class ValidationTests: XCTestCase {

    var validation: Validation!
    override func setUp() {
        super.setUp()
        validation = Validation()
    }

    override func tearDown() {
        validation = nil
        super.tearDown()
    }

    var emailLbl : String?
    var passwordLbl : String?
    func testValidLogin() {
        let isValid = validation.checkLoginValidation(email: "ram@gmail.com", emailWrongLbl: &emailLbl, password: "1234", passwordWrongLbl: &passwordLbl)
        XCTAssertTrue(isValid, "User Detail is not correct")
    }
    func testNotValidLogin() {
        let isValid = validation.checkLoginValidation(email: "ram@gmail.com", emailWrongLbl: &emailLbl, password: "1", passwordWrongLbl: &passwordLbl)
        // compare to both isvlaid == true ??
        XCTAssertEqual(isValid, true)
    }
    func testValidPass() {
        let isValid = validation.checkLoginValidation(email: "ram@gmail.com", emailWrongLbl: &emailLbl, password: "", passwordWrongLbl: &passwordLbl)
        // compare to both isvlaid == false because password is empty ??
        XCTAssertEqual(isValid, false)
    }
    func testValidEmail() {
        let isValid = validation.checkLoginValidation(email: "ram.gmail.com", emailWrongLbl: &emailLbl, password: "1234", passwordWrongLbl: &passwordLbl)
        // compare to both isvlaid == false because password is empty ??
        XCTAssertEqual(isValid, false)
    }

}



