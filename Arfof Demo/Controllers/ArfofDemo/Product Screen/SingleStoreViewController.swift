//
//  SingleStoreViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/27/23.
//

import UIKit

class SingleStoreViewController: UIViewController {
    
    //MARK: Variables
    let screenWidth = UIScreen.main.bounds.width
    var swipeIndex = 0
    
    //property of product tab
    var productImages: [String] = ["shoulderBag", "bag2", "bag3","bag4","bag5","bag3"]
    
    //protery of overview page
    var timeShow : Bool = false
    var noOfDaysToShow = 1
    private let allDays: [StoreOpenDays] = [
        StoreOpenDays(day: "Sunday", detail: "10:00 AM - 09:00 PM"),
        StoreOpenDays(day: "Monday", detail: "10:00 AM - 09:00 PM"),
        StoreOpenDays(day: "Tuesday", detail: "10:00 AM - 09:00 PM"),
        StoreOpenDays(day: "Wednesday", detail: "10:00 AM - 09:00 PM"),
        StoreOpenDays(day: "Thursday", detail: "10:00 AM - 09:00 PM"),
        StoreOpenDays(day: "Friday", detail: "Closed"),
        StoreOpenDays(day: "Saturday", detail: "Closed"),
    ]
    var currentDay : String = ""
    var currentDayToShow: [StoreOpenDays] = []
    var daysToShow: [StoreOpenDays] = []
    
    
    //MARK: outlets
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var swipeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var currentPageTabView: UIView!
    @IBOutlet weak var productTabView: UIView!
    @IBOutlet weak var overviewTabView: UIView!
    @IBOutlet weak var offerTabView: UIView!
    @IBOutlet weak var reviewTabView: UIView!
    @IBOutlet weak var currentPageTabViewLeftContraint: NSLayoutConstraint!
    
    // product tab outlets
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    //overview tab outlets
    
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var storeTimeButtonView: UIView!
    @IBOutlet weak var showButton: UIImageView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    
    //offers tab outlets
    
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var offersCollectionView: UICollectionView!
    
    //review tab outlets
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScreen()
        
        //        // for now
        //        headerView.backgroundColor = UIColor.white
        //        headerView.layer.shadowColor = UIColor.gray.cgColor
        //        headerView.layer.shadowOpacity = 0.5
        //        headerView.layer.shadowRadius = 5
        //        headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    //MARK: Action Outlets
    @IBAction func productTabAction(_ sender: Any) {
        swipeIndex = 0
        setContainerView()
    }
    
    @IBAction func overviewTabAction(_ sender: Any) {
        swipeIndex = 1
        setContainerView()
    }
    
    @IBAction func offersTabAction(_ sender: Any) {
        swipeIndex = 2
        setContainerView()
    }
    @IBAction func reviewTabAction(_ sender: Any) {
        swipeIndex = 3
        setContainerView()
    }
    
    //MARK: Scroll Function
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == myScrollView{
            let scrollOffset = scrollView.contentOffset.y
            if (scrollOffset > 0){
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
            if scrollOffset > 350{
                scrollView.contentOffset.y = 350
            }
            if(gridCollectionView.contentOffset.y < 350){
                gridCollectionView.contentOffset.y = scrollOffset
            }
        }
        if scrollView == gridCollectionView {
            let height: CGFloat = 350
            let newOffset = min(gridCollectionView.contentOffset.y, height)
            
            if newOffset != myScrollView.contentOffset.y {
                myScrollView.contentOffset.y = newOffset
            }
        }
    }
    
    
    
    //MARK: Functions
    //changing bar button underlline
    func changebarButtonUnderLine(buttonNo : Int){
        currentPageTabViewLeftContraint.constant = 0 + ((screenWidth-20) / 4 * CGFloat(buttonNo))
    }
    
    func setScreen(){
        heightOfCollectionView.constant = 80*3
        addGestures()
        setCurrentDay()
        setContainerView()
        setSwipeViewHeight()
        
    }
    
    func setSwipeViewHeight(){
        let screenheight = UIScreen.main.bounds.height
        print("screen height \(screenheight)")
        
        var topSafeAreaHeight: CGFloat = 0
        var bottomSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = safeFrame.minY
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
        print("top safe area space : \(topSafeAreaHeight)")
        print("Bottom safe area space : \(bottomSafeAreaHeight)")
        
        // 120 headerView + tabView
        let height = screenheight - topSafeAreaHeight - bottomSafeAreaHeight - 120
        print("swipeView Height \(height)" )
        swipeViewHeight.constant = height
        
    }
    
    // Hide all views of stackview(container)
    func setContainerView(){
        productView.isHidden = true
        overviewView.isHidden = true
        offerView.isHidden = true
        reviewView.isHidden = true
        changebarButtonUnderLine(buttonNo: swipeIndex)
        print("SwipeIndex : \(swipeIndex)")
        
        if swipeIndex == 0{
            productView.isHidden = false
        }
        else if swipeIndex == 1{
            overviewView.isHidden = false
        }
        else if swipeIndex == 2{
            offerView.isHidden = false
        }
        else if swipeIndex == 3{
            reviewView.isHidden = false
        }
    }
    func setCurrentDay(){
        let currentDate = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        currentDay = dayFormatter.string(from: currentDate)
        
        for item in allDays {
            if item.day == currentDay {
                currentDayToShow = [item]
                break
            }
        }
        daysToShow = currentDayToShow
    }
    func addGestures(){
        //swipe gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        swipeView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeView.addGestureRecognizer(swipeLeft)
        
        //getsure on overview screen store open days view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeTimeTapped))
        storeTimeButtonView.addGestureRecognizer(tapGesture)
    }
    @objc func storeTimeTapped(){
        if(timeShow == false){
            showButton.image = UIImage(named: "arrow-up")
            timeShow = true
            CollectionViewHeight.constant = 140
            timeCollectionView.reloadData()
            daysToShow = allDays
            
        }
        else{
            showButton.image = UIImage(named: "arrow-down")
            timeShow = false
            CollectionViewHeight.constant = 20
            daysToShow = currentDayToShow
        }
        timeCollectionView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if self.swipeIndex > 0 {
                    self.swipeIndex -= 1
                    self.setContainerView()
                }
            case UISwipeGestureRecognizer.Direction.left:
                if self.swipeIndex < 3 {
                    self.swipeIndex += 1
                    self.setContainerView()
                }
            default:
                break
            }
        }
    }
}

//MARK: - Collection view methods
extension SingleStoreViewController : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    //no of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == gridCollectionView{
            return 2
            
        }
        return 1
    }
    
    // no of items in each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gridCollectionView{
            return productImages.count
        }else if collectionView == timeCollectionView{
            return daysToShow.count
        }else if collectionView == offersCollectionView{
            return 1
        }
        return 3
    }
    
    // define cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gridCollectionView{
            let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: "StoreProductCell", for: indexPath) as! StoreProductCell
            cell.productImage.image = UIImage(named: productImages[indexPath.row])
            return cell
        }
        else if collectionView == timeCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreTimeCell", for: indexPath)as! StoreTimeCell
            
            cell.dayLabel.text = daysToShow[indexPath.item].day
            cell.detailLabel.text = daysToShow[indexPath.item].detail
            
            return cell
        }else if collectionView == offersCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreOfferCell", for: indexPath) as! StoreOfferCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreReviewCell", for: indexPath) as! StoreReviewCell
        return cell
        
    }
    
    //size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == gridCollectionView{
            let cellWidth = (collectionView.frame.width - 60)/2
            return CGSize(width: cellWidth, height: cellWidth + 60)
        }
        if collectionView == timeCollectionView{
            return CGSize(width: collectionView.frame.width , height: 20)
        }else if collectionView == offersCollectionView{
            return CGSize(width: (collectionView.frame.width - 40) , height: 290 )
        }else if collectionView == reviewsCollectionView{
            return CGSize(width: collectionView.frame.width, height: 80)
        }
        return CGSize(width: 0, height: 0)
    }
    
    //for header view in section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.gridCollectionView {
            return CGSize(width: self.gridCollectionView.frame.size.width, height: 50)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == gridCollectionView{
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StoreProductCellHeader", for: indexPath) as! StoreProductCellHeader
                if(indexPath.section == 0){
                    headerView.sectionLabel.text = "Newly Added"
                }
                else{
                    headerView.sectionLabel.text = "All Products"
                }
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
}

//MARK: Cell Classes

class StoreProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: customImage!
    
}

class StoreTimeCell: UICollectionViewCell{
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

class StoreReviewCell: UICollectionViewCell {
    
}

class StoreOfferCell: UICollectionViewCell {
    
    
}
// header of products section in collection view
class StoreProductCellHeader: UICollectionReusableView {
    
    @IBOutlet weak var sectionLabel: UILabel!
    
}







// not scrolling synchronized...
//MARK: Scroll Function
//func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    
//    if scrollView == myScrollView{
//        let scrollOffset = scrollView.contentOffset.y
//        if (scrollOffset > 0){
//            headerView.backgroundColor = UIColor.white
//            headerView.layer.shadowColor = UIColor.gray.cgColor
//            headerView.layer.shadowOpacity = 0.5
//            headerView.layer.shadowRadius = 5
//            headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
//        }
//        else {
//            headerView.backgroundColor = UIColor.clear
//            headerView.layer.shadowColor = UIColor.clear.cgColor
//        }
//        if scrollOffset > 350{
//            scrollView.contentOffset.y = 350
//        }
//        if(gridCollectionView.contentOffset.y < 350){
//            gridCollectionView.contentOffset.y = scrollOffset}
//    }
//    if scrollView == gridCollectionView {
//        let height: CGFloat = 350
//        let newOffset = min(gridCollectionView.contentOffset.y, height)
//        
//        if newOffset != myScrollView.contentOffset.y {
//            myScrollView.contentOffset.y = newOffset
//        }
//    }
//}
