//
//  CustomButton.swift
//  Arfof Demo
//
//  Created by Guest on 12/1/23.
//

import Foundation
import UIKit
@IBDesignable
class customButton: UIButton {
    @IBInspectable  var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
class customView: UIView{
    @IBInspectable  var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable  var borderColor: UIColor = .black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable  var borderWidth: CGFloat = 1 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
}


@IBDesignable
class CustomViewShadow: customView {
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
}


@IBDesignable
class customImage: UIImageView{
    @IBInspectable  var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
class CustomStackView: UIStackView{
    @IBInspectable  var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable  var borderColor: UIColor = .black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable  var borderWidth: CGFloat = 1 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
}


@IBDesignable
class customLabel: UILabel {
    
    @IBInspectable var strikeThrough: Bool = false {
        didSet {
            updateText()
        }
    }
    
    @IBInspectable var underline: Bool = false {
        didSet {
            updateText()
        }
    }
    
    private func updateText() {
        guard let labelText = text else { return }
        
        let attributedString = NSMutableAttributedString(string: labelText)
        
        if strikeThrough {
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        }
        
        if underline {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        }
        
        attributedText = attributedString
    }
}
