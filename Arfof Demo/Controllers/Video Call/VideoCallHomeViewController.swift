//
//  VideoCallHomeViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 27/02/24.
//

import UIKit
import Firebase

//protocol for notifying incoming call screen , and videochat screen
protocol VideoCallHomeViewControllerDelegate: AnyObject {
    func removeIncomingCallScreen()
    func removeVideoCallScreen()
    func makeVideoCall()
}

class VideoCallHomeViewController: UIViewController {
    
    //MARK: Variables
    let userId = UserDefaults.standard.value(forKey: "userId") as? Int
    private var sender: Int = 1
    private var receiver: Int = 2
    private var observerSignalRef: DatabaseReference?
    private var requestSignalRef: DatabaseReference?
    private var callrequestSending = false
    var requestTimer: DispatchSourceTimer?
    static var delegate: VideoCallHomeViewControllerDelegate?
    
    @IBOutlet weak var greetLabel: UILabel!
    @IBOutlet weak var reciverImage: UIImageView!
    @IBOutlet weak var reciverName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    override func viewDidAppear(_ animated: Bool) {
        LOG("\(type(of: self)) viewDidAppear")
    }
    
    //MARK: IBActions
    @IBAction func logoutButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            UserDefaults.standard.removeObject(forKey: "userId")
            self.navigationController?.popViewController(animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func callButtonAction(_ sender: Any) {
        LOG("call button tapped")
        sendRequest(userID: "\(self.sender)", callStatus: "request")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
        vc.user = 1
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: Fucntions
    private func initializeView(){
        sender =  userId!
        receiver =  userId == 1 ? 2 : 1
        greetLabel.text = "Welcome \(userId == 1 ? "Tom" : "Jerry")!"
        reciverImage.image = UIImage(named: userId == 1 ? "jerry" : "tom")
        reciverName.text = userId == 1 ? "Jerry" : "Tom"
        setupFirebase()
        CallIncomingViewController.delegate = self
        VideoChatViewController.delegate =  self
    }
    
    private func setupFirebase() {
        self.observerSignalRef = Database.database().reference().child("CallRequest/\(receiver)")
        self.requestSignalRef = Database.database().reference().child("CallRequest/\(sender)")
        self.requestSignalRef?.onDisconnectRemoveValue()
        self.observerSingnal()
    }
    
    
    
    func observerSingnal() {
        self.observerSignalRef?.observe(.value) { snapshot in
            guard snapshot.exists() else { return }
            
          
            guard let message = snapshot.value as? [String: Any],
                  let callStatus = message["callStatus"] as? String else {
                LOG("Error: Invalid data format")
                return
            }
            LOG("call signal received, call status : \(callStatus)")
            
            if callStatus == "request"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CallIncomingViewController") as! CallIncomingViewController
                self.navigationController?.pushViewController(vc, animated: false)
            }else if callStatus == "requestEnd"{
                VideoCallHomeViewController.delegate?.removeIncomingCallScreen()
            }else if callStatus == "requestReject"{
                self.callrequestSending =  false
                VideoCallHomeViewController.delegate?.removeVideoCallScreen()
                self.sendRequest(userID: "\(self.sender)", callStatus: "close")
            }else if callStatus == "requestAccept"{
                self.callrequestSending =  false
                VideoCallHomeViewController.delegate?.makeVideoCall()
            }else if callStatus == "callCut" {
                self.callrequestSending =  false
                VideoCallHomeViewController.delegate?.removeIncomingCallScreen()
                VideoCallHomeViewController.delegate?.removeVideoCallScreen()
                self.sendRequest(userID: "\(self.sender)", callStatus: "close")
            }
        }
    }
    
    func sendRequest(userID: String, callStatus: String) {
        LOG("---sending Request ---")
        let message = ["userID": userID, "callStatus": callStatus] as [String : Any]
        self.requestSignalRef?.setValue(message) { (error, ref) in
            if let error = error {
                LOG("Error sending request: \(error.localizedDescription)")
            } else {
                LOG("Request sent successfully as :  \(callStatus) by : \(userID)")
                if callStatus == "request" {
                    self.callrequestSending = true
                    if let timer = self.requestTimer {
                        timer.cancel()
                    }
                    self.requestTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
                    self.requestTimer?.schedule(deadline: .now() + 10)
                    self.requestTimer?.setEventHandler { [weak self] in
                        self?.callRequestEnd()
                    }
                    self.requestTimer?.resume()
                }else if callStatus == "requestReject" {
                    LOG("requestRejected sent so : now closing call")
                    self.sendRequest(userID: "\(self.sender)", callStatus: "close")
                }
                else if callStatus == "requestEnd" {
                    LOG("requestEnd sent so : now closing call")
                    self.sendRequest(userID: "\(self.sender)", callStatus: "close")
                }
                else if callStatus == "callCut"{
                    self.sendRequest(userID: "\(self.sender)", callStatus: "close")
                }
            }
        }
    }
    
    func callRequestEnd(){
        if callrequestSending{
            VideoCallHomeViewController.delegate?.removeVideoCallScreen()
            sendRequest(userID: "\(sender)", callStatus: "requestEnd")
        }
    }
}

//MARK: Delegates
extension VideoCallHomeViewController : CallIncomingViewControllerDelegate{
    func declineCall() {
        LOG("Call Decline")
        sendRequest(userID: "\(sender)", callStatus: "requestReject")
    }
    
    func acceptCall() {
        LOG("Call Accept")
        sendRequest(userID: "\(sender)", callStatus: "requestAccept")
    }
}


extension VideoCallHomeViewController : VideoChatViewControllerDelegate{
    func videoCallCut() {
        callrequestSending =  false
        sendRequest(userID: "\(sender)", callStatus: "callCut")
    }
}
