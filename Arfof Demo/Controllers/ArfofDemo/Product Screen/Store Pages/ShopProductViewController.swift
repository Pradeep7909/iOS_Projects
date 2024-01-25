//
//  ShopProductViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/11/23.
//

import UIKit

class ShopProductViewController: UIViewController {

    var productImages: [String] = ["shoulderBag", "bag2", "bag3","bag4","bag5","bag3"]
    
    //MARK: - Outlets
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridCollectionView.isScrollEnabled = false
        print(gridCollectionView.contentOffset.y)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(gridCollectionView.contentOffset.y)
        if(gridCollectionView.contentOffset.y == 0){
            gridCollectionView.isScrollEnabled = false
        }
    }
    
    // MARK: - Navigation
    
    // Enable scrolling for the inner UICollectionView
       func enableCollectionViewScrolling() {
           gridCollectionView.isScrollEnabled = true
       }

       // Reset scrolling for the inner UICollectionView
       func resetCollectionViewScrolling() {
           gridCollectionView.isScrollEnabled = false
       }
}


//MARK: - Extension

extension ShopProductViewController : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
      
    //no of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
    
    // no of items in each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    // define cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: "productGridCell", for: indexPath) as! productGridCell
        cell.productImage.image = UIImage(named: productImages[indexPath.row])
        return cell
    }
    
    //for header view in section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "productsHeader", for: indexPath) as! productsHeader
            if(indexPath.section == 0){
                headerView.titleLabel.text = "Newly Added"
            }
            else{
                headerView.titleLabel.text = "All Products"
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    //size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 60)/2
        return CGSize(width: cellWidth, height: cellWidth + 60)
    }
   
}
