//
//  ChatViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 24/02/24.
//

import UIKit
import WebRTC
import SwiftyJSON
import Firebase

protocol VideoChatViewControllerDelegate: AnyObject {
    func videoCallCut()
}


class VideoChatViewController: UIViewController, RTCVideoViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //MARK: Variables
    private var sender: Int = 1
    private var receiver: Int = 2
    var user : Int = 0
    var onVideoCallScreen : Bool = false
    
    private var screenWidth : CGFloat = 300
    private var screenHeight : CGFloat = 600
    private var safeAreaTopHeight : CGFloat = 40
    private var isAudioMuted : Bool = false
    private var isSpeakerEnabled = false
    private var isUsingFrontCamera = true
    private var audioSession = AVAudioSession.sharedInstance()
    
    static var delegate : VideoChatViewControllerDelegate?
    
    
    private var peerConnectionFactory: RTCPeerConnectionFactory! = nil
    private var peerConnection: RTCPeerConnection! = nil
    private var remoteVideoTrack: RTCVideoTrack?
    private var audioSource: RTCAudioSource?
    private var videoSource: RTCVideoSource?
    private var videoCapturer: RTCCameraVideoCapturer?
    private var observerSignalRef: DatabaseReference?
    private var offerSignalRef: DatabaseReference?
    
    //MARK: IBOutlets
    @IBOutlet weak var cameraPreview: RTCCameraPreviewView!
    @IBOutlet weak var remoteVideoView: RTCMTLVideoView!
    
    @IBOutlet weak var cameraPreviewTralingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraPreviewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraPreviewWidth: NSLayoutConstraint!
    @IBOutlet weak var cameraPreviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var callImageView: CustomView!
    @IBOutlet weak var muteButtonImage: UIImageView!
    @IBOutlet weak var videoButtonImage: UIImageView!
    @IBOutlet weak var blurCameraPreview: UIVisualEffectView!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var callingLabel: UILabel!
    
    
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LOG("ViewCall ViewDidLoad")

        initializeView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LOG("\(type(of: self)) viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if peerConnection != nil  && peerConnection.iceConnectionState != RTCIceConnectionState.closed {
            peerConnection.close()
            let jsonClose: JSON = ["type": "close"]
            
            let message = jsonClose.dictionaryObject
            LOG("sending close message")
            let ref = Database.database().reference().child("Call/\(sender)")
            ref.setValue(message) { (error, ref) in
                LOG("Dang send SDP Error -->>  \( error.debugDescription) ")
            }
        }
        if remoteVideoTrack != nil {
            remoteVideoTrack?.remove(remoteVideoView)
        }
        remoteVideoTrack = nil
    }
    
    
    //MARK: IBActions

    @IBAction func connectButtonAction(_ sender: Any) {
        LOG("hangupButtonAction")
        hangUp()
    }
    
    
    @IBAction func flipCamera(_ sender: Any) {
        
        let newPosition: AVCaptureDevice.Position = (isUsingFrontCamera) ? .back : .front
        
        guard let activeDevice = videoCapturer?.captureSession.inputs.first as? AVCaptureDeviceInput else {
            LOG("No active capture device found.")
            return
        }
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
            LOG("No \(newPosition) camera available.")
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            videoCapturer?.captureSession.beginConfiguration()
            videoCapturer?.captureSession.removeInput(activeDevice)
            
            if videoCapturer?.captureSession.canAddInput(newInput) == true {
                videoCapturer?.captureSession.addInput(newInput)
            } else {
                LOG("Failed to add new input to capture session.")
            }
            
            videoCapturer?.captureSession.commitConfiguration()
        } catch {
            LOG("Error creating capture device input: \(error.localizedDescription)")
        }
        isUsingFrontCamera.toggle()
    }
    
    
    @IBAction func muteButton(_ sender: Any) {
        if let localStream = peerConnection?.localStreams.first {
            for track in localStream.audioTracks {
                isAudioMuted = !isAudioMuted
                track.isEnabled = !isAudioMuted
                LOG("Audio \(isAudioMuted ? "muted" : "unmuted")")
                muteButtonImage.image = UIImage(named: isAudioMuted ? "mute" : "mic")
            }
        } else {
            LOG("Error: No local stream found or no audio tracks in the local stream.")
        }
    }
    
    @IBAction func stopVideoShare(_ sender: Any) {
        // Toggle the video track's enabled state
        if let localStream = peerConnection?.localStreams.first {
            if let videoTrack = localStream.videoTracks.first {
                videoTrack.isEnabled = !videoTrack.isEnabled
                LOG("Video sharing \(videoTrack.isEnabled ? "resumed" : "paused")")
                videoButtonImage.image = UIImage(named: videoTrack.isEnabled ? "videoOn" : "videoOff")
                blurCameraPreview.isHidden = videoTrack.isEnabled ? true : false
            } else {
                LOG("Error: No video track in the local stream.")
            }
        } else {
            LOG("Error: No local stream found.")
        }
    }
    
    
    @IBAction func speakerToggleAction(_ sender: Any) {
        
        do {
            let session = RTCAudioSession.sharedInstance()
            session.lockForConfiguration()
            if isSpeakerEnabled {
                try session.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
            } else {
                try session.setCategory(AVAudioSession.Category.playAndRecord.rawValue, with: .defaultToSpeaker)
            }
            session.unlockForConfiguration()
            isSpeakerEnabled = !isSpeakerEnabled
            speakerImage.image = UIImage(named: isSpeakerEnabled ? "speakerOn" : "speakerOff")
            LOG("Speaker : \(isSpeakerEnabled)")
        } catch {
            LOG("Error toggling speaker: \(error.localizedDescription)")
        }
    }
    
    //MARK: Fucntions
    func initializeView(){
        VideoCallHomeViewController.delegate = self
        onVideoCallScreen = true
        sender =  user
        receiver =  user == 1 ? 2 : 1
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        safeAreaTopHeight = self.view.safeAreaInsets.top
        cameraPreview.backgroundColor = .clear
        remoteVideoView.backgroundColor = .clear
        blurCameraPreview.isHidden = true
        self.callImage.image = UIImage(named: "callEnd")
        self.callImageView.backgroundColor = .red
        callingLabel.addStroke(color: .darkGray, width: 2)
        setCameraPreviewFullScreen()
        callingLabel.text = user ==  2 ? "Connecting..." : "Calling..."
        
        //firebase & WebRTC setup
#if targetEnvironment(simulator)
        LOG("VideoCall cannot run on simulator")
        callingLabel.text = "Camera Not available"
        return
#endif
        initialSetup()
    }
    
    func initialSetup(){
        self.remoteVideoView.delegate = self
        self.peerConnectionFactory = RTCPeerConnectionFactory()
        self.startVideo(camera: .front)
        self.setupFirebase()
        peerConnection = prepareNewConnection()
    }
    
    //When call is not connected
    func setCameraPreviewFullScreen() {
        DispatchQueue.main.async {
            self.cameraPreviewTopConstraint.constant = -self.safeAreaTopHeight
            self.cameraPreviewTralingConstraint.constant = 0
            self.cameraPreviewWidth.constant = self.screenWidth
            self.cameraPreviewHeight.constant = self.screenHeight
            self.remoteVideoView.isHidden = true
            
            self.view.layoutIfNeeded()
        }
    }
    //When call is connected
    func setCameraPreviewSmall(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.cameraPreviewTopConstraint.constant = 20
                self.cameraPreviewTralingConstraint.constant = 20
                self.cameraPreviewWidth.constant = 100
                self.cameraPreviewHeight.constant = 120
                self.remoteVideoView.isHidden = false
                self.callingLabel.isHidden = true
               
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setupFirebase() {
        self.observerSignalRef = Database.database().reference().child("Call/\(receiver)")
        self.offerSignalRef = Database.database().reference().child("Call/\(sender)")
        
        self.offerSignalRef?.onDisconnectRemoveValue()
        self.observerSingnal()
        
    }
    
    
    func observerSingnal() {
        self.observerSignalRef?.observe(.value, with: { [weak self] (snapshot) in
            guard snapshot.exists() else { return }
            LOG("message: \(snapshot.value ?? "NO Value")")
            
            let jsonMessage = JSON(snapshot.value!)
            let type = jsonMessage["type"].stringValue
            switch (type) {
            case "offer":
                // offer
                LOG("Received offer ...")
                let offer = RTCSessionDescription(
                    type: RTCSessionDescription.type(for: type),
                    sdp: jsonMessage["sdp"].stringValue)
                self?.setOffer(offer)
                
            case "answer":
                // answer
                LOG("Received answer ...")
                let answer = RTCSessionDescription(
                    type: RTCSessionDescription.type(for: type),
                    sdp: jsonMessage["sdp"].stringValue)
                self?.setAnswer(answer)
                
            case "candidate":
                LOG("Received ICE candidate ...")
                let candidate = RTCIceCandidate(
                    sdp: jsonMessage["ice"]["candidate"].stringValue,
                    sdpMLineIndex: jsonMessage["ice"]["sdpMLineIndex"].int32Value,
                    sdpMid: jsonMessage["ice"]["sdpMid"].stringValue)
                self?.addIceCandidate(candidate)
                
            case "close":
                LOG("peer is closed ...")
                
//                self?.hangUp()
            default:
                return
            }
        })
    }
    
    
    //Start Capturing video
    func startVideo(camera : AVCaptureDevice.Position) {
        let audioSourceConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        audioSource = peerConnectionFactory.audioSource(with: audioSourceConstraints)
        
        let videoSource = peerConnectionFactory.videoSource()
        self.videoSource = videoSource
        LOG("Video source: \(videoSource)")
        
        self.videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)

        // Start the capture session of the videoCapturer
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: camera) {
            let format = RTCCameraVideoCapturer.supportedFormats(for: camera).last
            let fps = 60
            
            videoCapturer!.startCapture(with: camera,
                                        format: format!,
                                        fps: Int(fps)) { error in
                DispatchQueue.main.async {
                    LOG("displaying video")
                    self.cameraPreview.captureSession = self.videoCapturer?.captureSession
                    if let previewLayer = self.cameraPreview.layer as? AVCaptureVideoPreviewLayer {
                        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    }
                }
            }
        } else {
            LOG("camera not available")
        }
    }
    
    func prepareNewConnection() -> RTCPeerConnection {
        let configuration = RTCConfiguration()
        configuration.iceServers = [RTCIceServer.init(urlStrings: ["stun:stun.l.google.com:19302",
                                                                   "stun:stun2.l.google.com:19302",
                                                                   "stun:stun3.l.google.com:19302",
                                                                   "stun:stun4.l.google.com:19302"])]

        let peerConnectionConstraints = RTCMediaConstraints(
            mandatoryConstraints: nil, optionalConstraints: nil)
        
        let peerConnection = peerConnectionFactory.peerConnection(
            with: configuration,
            constraints: peerConnectionConstraints,
            delegate: self)

        let localStream = peerConnectionFactory.mediaStream(withStreamId: "VideoCall")
        let localAudioTrack = peerConnectionFactory.audioTrack(with: audioSource!, trackId: "audio" + "\(user)" )
        let localVideoTrack = peerConnectionFactory.videoTrack(with: videoSource!, trackId: "video" + "\(user)")
        localStream.addAudioTrack(localAudioTrack)
        localStream.addVideoTrack(localVideoTrack)

        peerConnection.add(localStream)
        
        return peerConnection
    }
    
    
    //MARK: Signal Transfer
    func makeOffer() {
        let constraints = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"],optionalConstraints: nil) // Offer
        let offerCompletion = { (offer: RTCSessionDescription?, error: Error?) in // Offer
            if error != nil {
                LOG("error \(String(describing: error))")
                return }
            LOG("createOffer() succsess")
            let setLocalDescCompletion = {(error: Error?) in // setLocalDescCompletion
                
                if error != nil { return }
                LOG("setLocalDescription() succsess")
                self.sendSDP(offer!)
            }
            self.peerConnection.setLocalDescription(offer!, completionHandler: setLocalDescCompletion)
        }
        self.peerConnection.offer(for: constraints, completionHandler: offerCompletion) // Offer
    }
    
    func makeAnswer() {
        LOG("sending Answer. Creating remote session description...")
    
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let answerCompletion = { (answer: RTCSessionDescription?, error: Error?) in
            if error != nil { return }
            LOG("createAnswer() succsess")
            let setLocalDescCompletion = {(error: Error?) in
                if error != nil { return }
                LOG("setLocalDescription() succsess")
                
                self.sendSDP(answer!)
            }
            self.peerConnection.setLocalDescription(answer!, completionHandler: setLocalDescCompletion)
        }
        self.peerConnection.answer(for: constraints, completionHandler: answerCompletion) // Answer
    }
    
    
    func sendSDP(_ desc: RTCSessionDescription) {
        LOG("---sending sdp ---")
        
        let jsonSdp: JSON = [ // JSON
            "sdp": desc.sdp, // SDP
            "type": RTCSessionDescription.string(for: desc.type) // offer  answer
        ]
        let message = jsonSdp.dictionaryObject
        self.offerSignalRef?.setValue(message) { (error, ref) in
            if error != nil {
                LOG("Dang sendIceCandidate -->> , \(error.debugDescription) ")
            }
        }
    }
    
    func setOffer(_ offer: RTCSessionDescription) {
        self.peerConnection.setRemoteDescription(offer, completionHandler: {(error: Error?) in
            if error == nil {
                LOG("setRemoteDescription(offer) succsess")
                self.makeAnswer() // setRemoteDescription Answer
            } else {
                LOG("setRemoteDescription(offer) ERROR: " + error.debugDescription)
            }
        })
    }
    
    func setAnswer(_ answer: RTCSessionDescription) {
        self.peerConnection.setRemoteDescription(answer, completionHandler: {
            (error: Error?) in
            if error == nil {
                LOG("setRemoteDescription(answer) succsess")
            } else {
                LOG("setRemoteDescription(answer) ERROR: " + error.debugDescription)
            }
        })
    }
    
    func addIceCandidate(_ candidate: RTCIceCandidate) {
        LOG("candidate is added.")
        peerConnection.add(candidate)
    }
    
    func hangUp() {
        
        LOG("CallHangUp fucntion called")
        LOG("onVideoCallScreen : \(onVideoCallScreen)")
        if onVideoCallScreen{
            VideoChatViewController.delegate?.videoCallCut()
            DispatchQueue.main.async{
                LOG("poped after call cut")
                self.onVideoCallScreen = false
                self.navigationController?.popViewController(animated: false)
            }
            if peerConnection != nil && peerConnection.iceConnectionState != RTCIceConnectionState.closed {
                peerConnection.close()
                let jsonClose: JSON = ["type": "close"]
                
                let message = jsonClose.dictionaryObject
                LOG("sending close message")
                let ref = Database.database().reference().child("Call/\(sender)")
                ref.setValue(message) { (error, ref) in
                    LOG("Dang send SDP Error -->>  \( error.debugDescription) ")
                }
            }
            if remoteVideoTrack != nil {
                remoteVideoTrack?.remove(remoteVideoView)
            }
            remoteVideoTrack = nil
            LOG("Call is closed.")
        }
    }
    
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        LOG("Remote video render on screen")
        setCameraPreviewSmall()
    }
}

// MARK: - Peer Connection
extension VideoChatViewController: RTCPeerConnectionDelegate {
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        LOG("\(#function): called.")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        LOG("-- peer.onaddstream()")
        DispatchQueue.main.async(execute: { () -> Void in
            // main
            if (stream.videoTracks.count > 0) {
                self.remoteVideoTrack = stream.videoTracks[0]
                // remoteVideoView
                self.remoteVideoTrack?.add(self.remoteVideoView)
                LOG("video is added to remote video..")
            }
        })
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        LOG("didRemove")
    }

    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        LOG("peerConnectionShouldNegotiate")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        LOG("didChange")
        var state = ""
        switch (newState) {
        case RTCIceConnectionState.checking: state = "checking"
        case RTCIceConnectionState.completed: state = "completed"
        case RTCIceConnectionState.connected: state = "connected"
        case RTCIceConnectionState.closed:
            state = "closed"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.hangUp()
            }
        case RTCIceConnectionState.failed:
            state = "failed"
            hangUp()
        case RTCIceConnectionState.disconnected: state = "disconnected"
            hangUp()
        default: break
        }
        LOG("ICE connection Status has changed to \(state)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        LOG("didChange")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        LOG("didGenerate")
        if candidate.sdpMid != nil {
            sendIceCandidate(candidate)
        } else {
            LOG("empty ice event")
        }
    }

    func sendIceCandidate(_ candidate: RTCIceCandidate) {
        LOG("---sending ICE candidate ---")
        let jsonCandidate: JSON = ["type": "candidate",
                                   "ice": [
                                    "candidate": candidate.sdp,
                                    "sdpMLineIndex": candidate.sdpMLineIndex,
                                    "sdpMid": candidate.sdpMid!
                                   ]
        ]
        
        let message = jsonCandidate.dictionaryObject
        
        self.offerSignalRef?.setValue(message) { (error, ref) in
            if error != nil {
                LOG("Dang sendIceCandidate -->> , \(error.debugDescription)")
            }
        }
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        LOG("didOpen")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        LOG("didRemove")
    }
}


//MARK: Delegate Methods
extension VideoChatViewController : VideoCallHomeViewControllerDelegate{
    func makeVideoCall() {
       LOG("Making Video Call")
        callingLabel.text = "Connecting..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
            self.makeOffer()
        }
    }
    
    func removeVideoCallScreen() {
        if onVideoCallScreen{
            onVideoCallScreen =  false
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func removeIncomingCallScreen() {
        //no use of these delegate method here.
    }
}
