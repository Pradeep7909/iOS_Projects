//
//  CallIncomingViewController.swift
//  iOS App
//
//  Created by Qualwebs on 28/02/24.
//

import UIKit

//protocl for notifiy about response
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
    
    //MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isConnectingCall{
            self.navigationController?.popViewController(animated: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        LOG("\(type(of: self)) viewDidAppear")
    }
    
    //MARK: IBAction
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
    
    //MARK: Fucntions
    private func initializeView(){
        onInComingCallScreen  = true
        VideoCallHomeViewController.delegate = self
        reciverImage.image = UIImage(named: userId == 1 ? "jerry" : "tom")
        receiverUserName.text = userId == 1 ? "Jerry" : "Tom"
    }
    
}

//MARK: Delegate Method
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
