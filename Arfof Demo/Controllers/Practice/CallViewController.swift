//
//  CallViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 23/02/24.
//

import UIKit
import AVFoundation
import WebRTC
import Firebase

class CallViewController: UIViewController {
    
    @IBOutlet weak var videoView: RTCCameraPreviewView!
    
    var captureSession: AVCaptureSession?
    var currentCamera: AVCaptureDevice?
    var currentCameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    var peerConnection: RTCPeerConnection?
    var localStream: RTCMediaStream?
    var factory: RTCPeerConnectionFactory!
//    var videoSource: RTCVideoSource?
    
    
    var remoteVideoView: RTCMTLVideoView? // Added
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        listenForSignalingMessages()
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.setupCaptureSession()
            self.setupPreviewLayer()
            self.startRunningCaptureSession()
//            self.setUpWebRTC()
//            self.setupRemoteVideoView()
        }
    }
    
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera)
        else {
            print("Unable to access back camera.")
            return
        }
        
        currentCamera = backCamera
        currentCameraInput = input
        
        captureSession?.addInput(input)
        
    }
    
    func setupPreviewLayer() {
        guard let captureSession = captureSession else { return }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = videoView.bounds
        videoView.layer.addSublayer(previewLayer!)
    }
    
    func startRunningCaptureSession() {
        captureSession?.startRunning()
    }
    
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        
        print("changeCameraButtonTapped")
        guard let currentCamera = currentCamera,
              let captureSession = captureSession,
              let currentCameraInput = currentCameraInput
        else {
            print("error changeCameraButtonTapped")
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(currentCameraInput)
        
        let newCamera: AVCaptureDevice? = (currentCamera.position == .back) ? frontCamera() : backCamera()
        
        guard let newInput = try? AVCaptureDeviceInput(device: newCamera!)
        else {
            print("Error switching cameras.")
            return
        }
        
        self.currentCameraInput = newInput
        self.currentCamera = newCamera
        
        captureSession.addInput(newInput)
        captureSession.commitConfiguration()
        
        
    }
    
    
    
    
    
    @IBAction func changeCameraButtonTapped(_ sender: Any) {
        print("changeCameraButtonTapped")
        guard let currentCamera = currentCamera,
              let captureSession = captureSession,
              let currentCameraInput = currentCameraInput
        else {
            print("error changeCameraButtonTapped")
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(currentCameraInput)
        
        let newCamera: AVCaptureDevice? = (currentCamera.position == .back) ? frontCamera() : backCamera()
        
        guard let newInput = try? AVCaptureDeviceInput(device: newCamera!)
        else {
            print("Error switching cameras.")
            return
        }
        
        self.currentCameraInput = newInput
        self.currentCamera = newCamera
        
        captureSession.addInput(newInput)
        captureSession.commitConfiguration()
    }
    
    func frontCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
    
    func backCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }
    
    
    func setupRemoteVideoView() {
        remoteVideoView = RTCMTLVideoView(frame: self.view.bounds)
        remoteVideoView?.videoContentMode = .scaleAspectFill
        self.view.addSubview(remoteVideoView!)
    }
    
}


extension CallViewController: RTCPeerConnectionDelegate{
    
    //delegate methods..
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        print("peerConnectionShouldNegotiate")
        // Generate and exchange a new offer or answer SDP message
        peerConnection.offer(for: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)) { (sdp, error) in
            guard let sdp = sdp else {
                print("Error creating offer: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.peerConnection?.setLocalDescription(sdp) { (error) in
                guard error == nil else {
                    print("Error setting local description: \(error!.localizedDescription)")
                    return
                }
                // Send the offer SDP to the remote peer
                
            }
        }
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("didChange : \(stateChanged)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        print("didRemove  \(stream)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("didAdd  \(stream)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("didChange, RTCIceConnectionState  \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("didChange , RTCIceGatheringState  \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        print("didRemove  \(candidates)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        print("didOpen  \(dataChannel) ")
    }
    
    // settup webrtc
    
    func setUpWebRTC() {
        print("setUpWebRTC")
        // Create peer connection factory
        let encoderFactory = RTCDefaultVideoEncoderFactory()
        let decoderFactory = RTCDefaultVideoDecoderFactory()
        factory = RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)
        
        // Create peer connection configuration
        let config = RTCConfiguration()
        config.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        // Create peer connection
        peerConnection = factory.peerConnection(with: config, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil), delegate: self)
        
        // Create local media stream
        let audioSource = factory.audioSource(with: nil)
        let audioTrack = factory.audioTrack(with: audioSource, trackId: "audio0")
        let videoSource = factory.videoSource()
        let videoTrack = factory.videoTrack(with: videoSource, trackId: "video0")
        localStream = factory.mediaStream(withStreamId: "stream")
        localStream?.addAudioTrack(audioTrack)
        localStream?.addVideoTrack(videoTrack)
        // Add local stream to peer connection
        peerConnection?.add(localStream!)
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        print("peerConnection")
        let candidateDict: [String: Any] = [
            "sdp": candidate.sdp,
            "sdpMLineIndex": candidate.sdpMLineIndex,
            "sdpMid": candidate.sdpMid ?? ""
        ]
        let data  : [String : Any] = [
            "type": "candidate", "candidate": candidateDict
        ]
        let message : [String : Any] = [
            "message" : data
        ]
        
        
        sendSignalingMessage(toRecipient: "RjPCY7n2JXdby3fCR6PlbkUDCi12", message: message)
    }
    
    func handleReceivedIceCandidate(candidate: [String: Any]) {
        print("handleReceivedIceCandidate")
        guard let sdp = candidate["sdp"] as? String,
              let sdpMLineIndex = candidate["sdpMLineIndex"] as? Int32,
              let sdpMid = candidate["sdpMid"] as? String
        else {
            return
        }
        let iceCandidate = RTCIceCandidate(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
        peerConnection?.add(iceCandidate)
    }
    
    func sendSignalingMessage(toRecipient: String, message: [String: Any]) {
        print("sendSignalingMessage")
        // Assuming you have a reference to your Firebase Realtime Database
        let databaseRef = Database.database().reference()
        databaseRef.child("signaling").child(toRecipient).setValue(message)
    }
    
    func listenForSignalingMessages() {
        // Assuming you have a reference to your Firebase Realtime Database
        let databaseRef = Database.database().reference()
        print("listenForSignalingMessages")
        // Replace "userId" with the actual user ID you're listening for signaling messages for
        let userId = "RjPCY7n2JXdby3fCR6PlbkUDCi12"
        
        
        databaseRef.child("signaling").child(userId).observe(.childAdded) { (snapshot) in
            guard let message = snapshot.value as? [String: Any] else {
                print("Error: Failed to parse ICE candidate message")
                return
            }
            
            // Handle the received signaling message (candidate)
            print("Received ICE candidate message: \(message)")
            //            self.handleSignalingMessage(message)
        }
        
        databaseRef.child("signaling").child(userId).observe(.childChanged) { (snapshot) in
            guard let message = snapshot.value as? [String: Any] else {
                print("Error: Failed to parse updated ICE candidate message")
                return
            }
            
            // Handle the updated signaling message (candidate)
            print("Updated ICE candidate message: \(message)")
            self.handleSignalingMessage(message)
        }
    }
    
    func handleSignalingMessage(_ message: [String: Any]) {
        guard let messageType = message["type"] as? String else {
            print("Error: Invalid signaling message - missing message type")
            return
        }
        
        switch messageType {
        case "offer":
            handleOfferMessage(message)
        case "answer":
            handleAnswerMessage(message)
        case "candidate":
            handleCandidateMessage(message)
        default:
            print("Warning: Unknown message type '\(messageType)'")
        }
    }
    
    // Handle offer message
    func handleOfferMessage(_ message: [String: Any]) {
        guard let offerSDP = message["sdp"] as? String else {
            print("Error: Missing offer SDP")
            return
        }
        // Process the offerSDP...
        print("Received offer SDP: \(offerSDP)")
        // Further processing of the offer SDP...
    }
    
    // Handle answer message
    func handleAnswerMessage(_ message: [String: Any]) {
        guard let answerSDP = message["sdp"] as? String else {
            print("Error: Missing answer SDP")
            return
        }
        // Process the answerSDP...
        print("Received answer SDP: \(answerSDP)")
        // Further processing of the answer SDP...
    }
    
    func handleCandidateMessage(_ message: [String: Any]) {
        guard let candidateDict = message["candidate"] as? [String: Any],
              let sdp = candidateDict["sdp"] as? String,
              let sdpMLineIndex = candidateDict["sdpMLineIndex"] as? Int,
              let sdpMid = candidateDict["sdpMid"] as? String else {
            print("Error: Missing or invalid ICE candidate details")
            return
        }
        print("connection is done")
        let iceCandidate = RTCIceCandidate(sdp: sdp, sdpMLineIndex: Int32(sdpMLineIndex), sdpMid: sdpMid)
        peerConnection?.add(iceCandidate)
    }
}
