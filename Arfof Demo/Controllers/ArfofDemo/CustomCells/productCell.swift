//
//  itemCell.swift
//  Arfof Demo
//
//  Created by Guest on 11/30/23.
//

import UIKit
import Hero

class productCell: UICollectionViewCell {
    
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var itemContentView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productOldPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setProductCell()
    }
    
    private func setProductCell() {
        heartView.layer.shadowColor = UIColor.black.cgColor
        heartView.layer.shadowOpacity = 0.5
        heartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        heartView.layer.shadowRadius = 4.0
        
        // Apply strikethrough to productOldPrice label
        if let oldPriceText = productOldPrice.text {
            let attributedString = NSMutableAttributedString(string: oldPriceText)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.darkGray, range: NSMakeRange(0, attributedString.length))

            productOldPrice.attributedText = attributedString
        }
    }
}
