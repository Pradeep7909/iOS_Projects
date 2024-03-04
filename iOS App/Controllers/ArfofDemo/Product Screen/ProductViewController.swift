//
//  ProductViewController.swift
//  iOS App
//
//  Created by Guest on 12/6/23.
//

import UIKit
//import Agrume
import Hero

class ProductViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var similarItemsCollection: UICollectionView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var mainProductImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    

    
    var productImages: [String] = ["shoulderBag", "bag2", "bag3","bag4","bag5"]
    var selectedImage: UIImage?
    var transitioningView: UIView?
    var heroId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the initial image
        mainProductImage.image = selectedImage
        
        //for transition
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .selectBy(presenting: .none, dismissing: .fade)
        mainProductImage.heroID = heroId
        
        print("product screen \(heroId)")
        print("product screen by actual \(mainProductImage.heroID)")
        
        // Do any additional setup after loading the view.
        addGestures()

        myScrollView.delegate = self
    }
    
    //MARK: functions
    func addGestures(){
        // added gesture on back button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        
        // added gesture on image
        let productImagetap = UITapGestureRecognizer(target: self, action: #selector(productImageTapped))
        mainProductImage.addGestureRecognizer(productImagetap)
        
        //added gesture on shopName
       let shopNametap = UITapGestureRecognizer(target: self, action: #selector(shopNametapped))
       shopName.addGestureRecognizer(shopNametap)
        
    }
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func productImageTapped() {
//        let agrume = Agrume(image: mainProductImage.image!, background: .colored(UIColor.darkGray))
//        agrume.show(from: self)
    }
    @objc private func shopNametapped() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SingleStoreViewController") as! SingleStoreViewController
        self.navigationController?.pushViewController(controller, animated: true)
        print("Navigated to shop page")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == myScrollView{
            let scrollOffset = scrollView.contentOffset.y

            if scrollOffset > 0 {
                headerView.backgroundColor = UIColor.white
                headerView.layer.shadowColor = UIColor.gray.cgColor
                headerView.layer.shadowOpacity = 0.5
                headerView.layer.shadowRadius = 5
                headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
            }
            else {
                headerView.backgroundColor = UIColor.clear
                headerView.layer.shadowColor = UIColor.clear.cgColor
            }
        }
    }
}

extension ProductViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // for item inside cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = similarItemsCollection.dequeueReusableCell(withReuseIdentifier: "SimilarProductCell", for: indexPath) as! SimilarProductCell
        cell.productImage.image = UIImage(named: productImages[indexPath.row])
        return cell
    }
    
    //for navigation when click on cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

