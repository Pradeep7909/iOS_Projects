//
//  SimilarProductCell.swift
//  iOS App
//
//  Created by Guest on 12/6/23.
//

import UIKit

class SimilarProductCell: UICollectionViewCell {
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setProductCell()
    }
    
    private func setProductCell() {
        heartView.layer.shadowColor = UIColor.black.cgColor
        heartView.layer.shadowOpacity = 0.5
        heartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        heartView.layer.shadowRadius = 4.0
    }
}
