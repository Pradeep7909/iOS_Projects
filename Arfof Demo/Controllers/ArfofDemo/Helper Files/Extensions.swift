//
//  Extensions.swift
//  Arfof Demo
//
//  Created by Qualwebs on 01/03/24.
//

import Foundation
import UIKit

extension UILabel {
    func addStroke(color: UIColor, width: CGFloat) {
        let strokeAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: color,
            .strokeWidth: -width, // Negative width to draw stroke only outside of text
        ]
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeAttributes)
    }
}
