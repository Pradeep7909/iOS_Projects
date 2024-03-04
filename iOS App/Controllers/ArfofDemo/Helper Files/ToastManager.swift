//
//  ToastManager.swift
//  iOS App
//
//  Created by Qualwebs on 27/02/24.
//

import UIKit

class ToastManager {
    static let shared = ToastManager() // Singleton instance
    
    private init() {} // Ensure singleton
    
    func showToast(message: String, backgroundColor: UIColor, backgroundOpacity: CGFloat) {
        guard let topViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        let toastView = UIView(frame: CGRect(x: topViewController.view.frame.size.width/2 - 150, y: 100, width: 300, height: 35))
        toastView.backgroundColor = backgroundColor.withAlphaComponent(backgroundOpacity)
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        topViewController.view.addSubview(toastView)
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: toastView.frame.width, height: toastView.frame.height))
        toastLabel.backgroundColor = .clear
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastView.addSubview(toastLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5, animations: {
                toastView.alpha = 0.0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        }
    }
}

