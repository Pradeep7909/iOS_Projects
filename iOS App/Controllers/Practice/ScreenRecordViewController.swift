//
//  ScreenRecordViewController.swift
//  iOS App
//
//  Created by Qualwebs on 27/02/24.
//

import UIKit
import AVKit
import ReplayKit

class ScreenRecordViewController: UIViewController, RPPreviewViewControllerDelegate {
    
    @IBOutlet weak var screenRecordView: UIView! // UIView to display the screen recording
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start screen recording
//        startScreenRecording()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Stop screen recording when the view disappears
//        stopScreenRecording()
//    }
//    
//    func startScreenRecording() {
//        guard RPScreenRecorder.shared().isAvailable else {
//            print("Screen recording is not available")
//            return
//        }
//        
//        RPScreenRecorder.shared().startRecording(handler: { error in
//            if let error = error {
//                print("Error starting screen recording: \(error.localizedDescription)")
//            } else {
//                print("Screen recording started")
//                
//                // Display the screen recording
//                self.displayScreenRecording()
//            }
//        })
//    }
//    
//    func stopScreenRecording() {
//        RPScreenRecorder.shared().stopRecording(handler: { previewViewController, error in
//            if let error = error {
//                print("Error stopping screen recording: \(error.localizedDescription)")
//            } else if let previewViewController = previewViewController {
//                // Screen recording stopped successfully
//                if let previewController = previewViewController as? RPPreviewViewController {
//                    previewController.previewControllerDelegate = self
//                }
//                // Handle the previewViewController here, if needed
//            }
//        })
//    }
//    
//    func displayScreenRecording() {
//        // Get the live broadcast URL
//        guard let broadcastURL = RPScreenRecorder.shared().broadcastURL else {
//            print("No broadcast URL available")
//            return
//        }
//        
//        // Create an AVPlayer with the broadcast URL
//        let player = AVPlayer(url: broadcastURL)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = screenRecordView.bounds
//        screenRecordView.layer.addSublayer(playerLayer)
//        
//        // Start playing the screen recording
//        player.play()
//        
//        self.player = player
//        self.playerLayer = playerLayer
//    }
}
