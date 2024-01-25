//
//  File.swift
//  Arfof Demo
//
//  Created by Qualwebs on 10/01/24.
//
import UIKit

class ActivityIndicator {
    static var overlayView = UIView()
    static var activityIndicator = UIActivityIndicatorView()

    static func show(view: UIView) {
        DispatchQueue.main.async {
            self.overlayView = UIView(frame: view.bounds)
            self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.addSubview(self.overlayView)

            self.activityIndicator.center = view.center
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.startAnimating()
            self.activityIndicator.style = .large
            self.activityIndicator.color = K_PURPLE_COLOR
            view.addSubview(self.activityIndicator)
        }
    }

    static func showPosition(view: UIView, center: CGPoint) {
        DispatchQueue.main.async {
            self.overlayView = UIView(frame: view.bounds)
            self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.addSubview(self.overlayView)

            self.activityIndicator.center = center
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.startAnimating()
            self.activityIndicator.style = .large
            self.activityIndicator.color = K_PURPLE_COLOR
            view.addSubview(self.activityIndicator)
        }
    }

    static func hide() {
        DispatchQueue.main.async{
            overlayView.removeFromSuperview()
            activityIndicator.stopAnimating()
        }
    }
}


