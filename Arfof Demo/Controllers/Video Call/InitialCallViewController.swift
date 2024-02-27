//
//  InitialCallViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 24/02/24.
//

import UIKit
import iOSDropDown

class InitialCallViewController: UIViewController {

    var user : Int = 1
    let dropDown = DropDown()
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTextField: DropDown!
    @IBOutlet weak var noUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeScreen()
    }
    
    @IBAction func connectButtonAction(_ sender: Any) {
        if userLabel.text == "User"{
            noUserLabel.isHidden = false
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func initializeScreen(){
        noUserLabel.isHidden = true
        userTextField.optionArray = ["user1" , "user2"]
        userTextField.didSelect { selectedText, index, id in
            self.userLabel.text = "\(selectedText)"
            self.user = index + 1
            self.noUserLabel.isHidden = true
        }
    }
    
}
