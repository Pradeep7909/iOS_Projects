//
//  ShopReviewViewController.swift
//  iOS App
//
//  Created by Guest on 12/11/23.
//

import UIKit

class ShopReviewViewController: UIViewController {

    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        heightOfCollectionView.constant = 80*3
    }
}

extension ShopReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //these function is not even executing i think problem is of height of collection view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! reviewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

