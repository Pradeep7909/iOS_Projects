//
//  HomeScreenViewController.swift
//  iOS App
//
//  Created by Guest on 11/29/23.
//

import UIKit
import Hero

class HomeScreenViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var accessoriesView: UIView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var accessoriesImage: UIImageView!
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var trendingItemsCollection: UICollectionView!
    
    @IBOutlet weak var popularItemsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var wallCollection: UICollectionView!
    @IBOutlet weak var myPage: UIPageControl!
    
    // for animation.. just trying
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var headerBlurView: UIVisualEffectView!
    
    var productImages: [String] = ["shoulderBag", "bag2", "bag3","bag4","bag5"]
    var wallImages: [String] = ["wall1", "wall2", "wall3", "wall4", "wall5"]
    var automaticScrollTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.delegate = self
        // Do any additional setup after loading the view.
        setScreen()
        hideKeyboardTappedAround()
        
        //image slide by default
        startAutomaticScrollTimer()
        
    }
    
    // MARK: - functions
    func setScreen(){
        setSearchField()
        myPage.currentPage = 0
        myPage.numberOfPages = 5
        wallCollection.layer.cornerRadius = 20
    }
    func setSearchField(){
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = UIColor.darkGray
        searchImageView.contentMode = .scaleAspectFit
        searchField.rightViewMode = .always
        searchField.rightView = searchImageView
    }
    
    // for header animation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == myScrollView{
            let scrollOffset = scrollView.contentOffset.y
            
            if scrollOffset > 100 {
                UIView.animate(withDuration: 0.8){
                    self.headerBlurView.alpha = 1
                }
            }
            else {
                UIView.animate(withDuration: 0.8){
                    self.headerBlurView.alpha = 0
                }
            }
        }
        
    }
    
    func startAutomaticScrollTimer() {
        automaticScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }
    func stopAutomaticScrollTimer() {
        automaticScrollTimer?.invalidate()
        automaticScrollTimer = nil
    }
    
    @objc func scrollToNextImage() {
        var index = myPage.currentPage
        if(index < wallImages.count - 1 ){
            index = index+1
        }
        else{
            index = 0
        }
        myPage.currentPage = index
        wallCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        
    }
}

//MARK: - Extension
// for collection view..
extension HomeScreenViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // for item inside cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == wallCollection {
            // Use wallCell for wallCollection
            let cell = wallCollection.dequeueReusableCell(withReuseIdentifier: "wallCell", for: indexPath) as! dailyWallCell
            cell.wallImage.image = UIImage(named: wallImages[indexPath.row])
            return cell
        }else {
            let cell = trendingItemsCollection.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! productCell
            cell.productImage.image = UIImage(named: productImages[indexPath.row])
            cell.productImage.heroID = "CustomImageTransition_\(indexPath.row)"
            print("hero id of each cell = \(String(describing: cell.productImage.heroID))")
            return cell
        }
    }
    
    //for navigation when click on cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == wallCollection {
            print("Navigation is not added yet to these..")
        } else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            let selectedCell = collectionView.cellForItem(at: indexPath) as! productCell
            controller.selectedImage = selectedCell.productImage.image
            controller.heroId = "CustomImageTransition_\(indexPath.row)"
            print("ID before navigation of product screen \(controller.heroId)")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == wallCollection{
            return CGSize(width: collectionView.frame.width, height: 190)
        }
        return CGSize(width: 150, height: 208)
    }
    
    
    // for page controllor of images
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Stop the automatic scrolling timer when manual scrolling begins
        if scrollView == wallCollection{
            stopAutomaticScrollTimer()
        }
    }
    
    func scrollViewDidEndDecelerating (_ scrollView: UIScrollView) {
        // Restart the automatic scrolling timer when manual scrolling ends
        if scrollView == wallCollection {
            startAutomaticScrollTimer()
            let visibleRect = CGRect(origin: wallCollection.contentOffset, size: wallCollection.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            if let indexPath = wallCollection.indexPathForItem(at: visiblePoint) {
                myPage.currentPage = indexPath.item
            }
        }
    }
}



