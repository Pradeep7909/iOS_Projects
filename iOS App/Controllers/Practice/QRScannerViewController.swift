//
//  QRScannerViewController.swift
//  iOS App
//
//  Created by Qualwebs on 02/03/24.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController{
    
    
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var qrLabel: UILabel!
    
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var isCapturing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrInitialize()
    }
    
    @IBAction func captureQR(_ sender: Any) {
        // If capture session is not running, start it
        if !isCapturing {
            captureSession.startRunning()
            isCapturing = true
        }
    }
    
    
    private func qrInitialize(){
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("Could not add video input")
                return
            }
        } catch {
            print("Error creating AVCaptureDeviceInput: \(error.localizedDescription)")
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Could not add metadata output")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scannerView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
    
    
}

extension QRScannerViewController : AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if !metadataObjects.isEmpty {
            captureSession.stopRunning()
            isCapturing = false
            if let metadataObject = metadataObjects.first {
                if let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject {
                    if readableObject.type == .qr {
                        // Get the QR code content
                        if let qrCodeContent = readableObject.stringValue {
                            print("QR Code detected: \(qrCodeContent)")
                            qrLabel.text = qrCodeContent
                        }
                    }
                }
            }
        }
    }
}
