//
//  CallIncomingViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 28/02/24.
//

import UIKit

protocol CallIncomingViewControllerDelegate: AnyObject {
    func declineCall()
    func acceptCall()
}


class CallIncomingViewController: UIViewController{

    let userId = UserDefaults.standard.value(forKey: "userId") as? Int
    private var onInComingCallScreen : Bool = false
    static var delegate : CallIncomingViewControllerDelegate?
    private var isConnectingCall : Bool = false
    
    @IBOutlet weak var reciverImage: UIImageView!
    @IBOutlet weak var receiverUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isConnectingCall{
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    @IBAction func acceptCallButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
        vc.user = 2
        self.navigationController?.pushViewController(vc, animated: false)
        isConnectingCall =  true
        CallIncomingViewController.delegate?.acceptCall()
    }
    
    @IBAction func declineCallButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        onInComingCallScreen  = false
        CallIncomingViewController.delegate?.declineCall()
    }
    
    func initializeView(){
        onInComingCallScreen  = true
        VideoCallHomeViewController.delegate = self
        reciverImage.image = UIImage(named: userId == 1 ? "jerry" : "tom")
        receiverUserName.text = userId == 1 ? "Jerry" : "Tom"
    }
    
}

extension CallIncomingViewController : VideoCallHomeViewControllerDelegate{
    func makeVideoCall() {
        // no use of call method here.
    }
    
    func removeVideoCallScreen() {
        //no use of these delegate method here.
    }
    
    func removeIncomingCallScreen() {
        LOG("removeIncomingCallScreen")
        if onInComingCallScreen{
            self.navigationController?.popViewController(animated: false)
        }
    }
}
