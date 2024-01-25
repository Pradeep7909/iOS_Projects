////
////  SingleStoreViewController.swift
////  Arfuf
////
////  Created by Sagar Pandit on 01/07/21.
////
//
//import UIKit
//import MapKit
//import ImageSlideshow
//
//class SingleStoreViewControllercheck: MainViewController {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(scrollView == self.mainScrollView){
//            if(scrollView.contentOffset.y > 0){
//                UIView.animate(withDuration: 0.1) {
//                    self.topBarView.backgroundColor = Singleton.shared.themeColor == K_DARK_THEME ?  K_DARK_GRAY_COLOR:.white.withAlphaComponent(1)
//                    self.topBarView.shadowColor = Singleton.shared.themeColor == K_DARK_THEME ?  K_DARK_GRAY_COLOR:.white.withAlphaComponent(1)
//                    self.businessName.text = self.BusniessName.text
//                    self.businessName.isHidden = false
//                    self.topBarView.shadowOpacity = 1
//                    self.mainScrollView.setNeedsLayout()
//                }
//            }else {
//                UIView.animate(withDuration: 0.1) {
//                    self.businessName.isHidden = true
//                    self.topBarView.backgroundColor = .clear
//                    self.topBarView.shadowColor = .clear
//                    self.topBarView.shadowOpacity = 0
//                    self.mainScrollView.setNeedsLayout()
//                }
//            }
//        }
//
//        if(scrollView == self.categoryCollection){
//            let height = self.backgroundImage.frame.size.height + (self.view.frame.size.height > 900.0 ? 55.0:(self.view.frame.size.height > 800.0 ? 60.0:75.0))
//            if(self.categoryCollection.contentOffset.y < height) {
//                if  (self.categoryCollection.contentOffset.y > 0) {
//                    if(self.mainScrollView.contentOffset.y <= self.categoryCollection.contentOffset.y){
//                        self.mainScrollView.setContentOffset(self.categoryCollection.contentOffset, animated: false)
//                    }
//                    self.mainScrollView.setNeedsLayout()
//                } else {
//                    if(self.mainScrollView.contentOffset.y <= self.categoryCollection.contentOffset.y){
//                        self.mainScrollView.setContentOffset(self.categoryCollection.contentOffset, animated: false)
//                    }
//                    self.mainScrollView.setNeedsLayout()
//                }
//            } else {
//                self.mainScrollView.setContentOffset(CGPoint(x: 0.0, y: height), animated: false)
//                self.mainScrollView.setNeedsLayout()
//            }
//        }
//
//        if(scrollView == self.categoryCollection){
//            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && (scrollView.contentOffset.y > 50) && !isLoadingList){
//                self.isLoadingList = true
//                self.loadMoreItemsForList()
//            }
//        }
//
//        //        if scrollView == self.mainScrollView {
//        //            // Calculate the initial position of the sticky view
//        //            let initialStickyViewPosition = self.mainScrollView.contentOffset.y + mainScrollTop
//        //
//        //            // Update the position of the sticky view as you scroll
//        //            if self.mainScrollView.contentOffset.y >= initialStickyViewPosition {
//        //                // If the sticky view reaches its sticky position, fix it to the top of the parent collection view
//        //                self.tabStackView.frame.origin.y = self.mainScrollView.contentOffset.y - mainScrollTop
//        //            } else {
//        //                // Otherwise, keep the sticky view at its initial position
//        //                self.tabStackView.frame.origin.y = mainScrollTop
//        //            }
//        //
//        //            // Ensure the sticky view doesn't go beyond the top of the parent collection view
//        //            if self.tabStackView.frame.origin.y < 0 {
//        //                self.tabStackView.frame.origin.y = 0
//        //            }
//        //        }
//    }
//
//    func loadMoreItemsForList(){
//        pagination += 1
//        self.getBusinessDetail()
//    }
//
//    //MARK: IBOutlets
//    @IBOutlet weak var categoryCollection: UICollectionView!
//
//    @IBOutlet weak var productView: UIView!
//    @IBOutlet weak var overviewView: UIView!
//    @IBOutlet weak var reviewsView: UIView!
//    @IBOutlet weak var offersView: UIView!
//    @IBOutlet weak var productLabel: DesignableUILabel!
//    @IBOutlet weak var overviewLabel: DesignableUILabel!
//    @IBOutlet weak var offersLabel: DesignableUILabel!
//    @IBOutlet weak var favouriteLabel: DesignableUILabel!
//    @IBOutlet weak var descriptLabel: DesignableUILabel!
//    @IBOutlet weak var backgroundImage: UIImageView!
//
//    @IBOutlet weak var favouriteToggleButton: CustomButton!
//    @IBOutlet weak var BusniessName: DesignableUILabel!
//    @IBOutlet weak var rateLabel: DesignableUILabel!
//    @IBOutlet weak var businessLogo: ImageView!
//
//    @IBOutlet weak var distanceLabel: DesignableUILabel!
//    @IBOutlet weak var noOfReviews: DesignableUILabel!
//    @IBOutlet weak var cosmosView: CosmosView!
//    @IBOutlet weak var swipeView: UIView!
//    @IBOutlet weak var achievementsCollectionView: UICollectionView!
//    @IBOutlet weak var reviewTableView: UITableView!
//    @IBOutlet weak var overViewView: UIView!
//    @IBOutlet weak var mainView: View!
//
//    @IBOutlet weak var heartIcon: UIImageView!
//    @IBOutlet weak var markFavouriteLabel: DesignableUILabel!
//    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
//    @IBOutlet weak var distanceView: UIView!
//    @IBOutlet weak var favouriteViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var offersTableView: UITableView!
//    @IBOutlet weak var noDataLabel: DesignableUILabel!
//    @IBOutlet weak var cartView: CartView!
//
//    @IBOutlet weak var deliveryOptionHeading: DesignableUILabel!
//    @IBOutlet weak var delvierylabel: DesignableUILabel!
//    @IBOutlet weak var deliveryTickImage: ImageView!
//    @IBOutlet weak var pickupLabel: DesignableUILabel!
//    @IBOutlet weak var pickupTickImage: ImageView!
//    @IBOutlet weak var quickDeliveryLabel: DesignableUILabel!
//    @IBOutlet weak var quickDeliveryImage: ImageView!
//
//    @IBOutlet weak var freeDeliveryLabel: DesignableUILabel!
//    @IBOutlet weak var deliveryChargeView: UIView!
//    @IBOutlet weak var deliveryChanrgeField: DesignableUITextField!
//    @IBOutlet weak var freeDeliverySwitchView: UIView!
//    @IBOutlet weak var freeDeliverySwitch: UISwitch!
//    @IBOutlet weak var quickView: UIStackView!
//    @IBOutlet weak var additionallyChargeLabel: DesignableUITextField!
//
//    @IBOutlet weak var timingLabel: DesignableUILabel!
//    @IBOutlet weak var aboutView: View!
//    @IBOutlet weak var downArrowImage: UIImageView!
//    @IBOutlet weak var gradientView: GradientView!
//    @IBOutlet weak var gradientBgView: UIImageView!
//    @IBOutlet weak var timingLocale: DesignableUILabel!
//    @IBOutlet weak var timingTable: UITableView!
//    @IBOutlet weak var timingImage: UIImageView!
//    @IBOutlet weak var cityTable: UICollectionView!
//    @IBOutlet weak var cityTableHeight: NSLayoutConstraint!
//
//    @IBOutlet weak var reviewStackView: View!
//    @IBOutlet weak var reviewCosmosView: CosmosView!
//    @IBOutlet weak var reviewTotalCount: DesignableUILabel!
//    @IBOutlet weak var distanceLeadingConstant: NSLayoutConstraint!
//    @IBOutlet weak var topView: View!
//    @IBOutlet weak var topBarView: View!
//    @IBOutlet weak var mainScrollView: UIScrollView!
//    @IBOutlet weak var businessName: DesignableUILabel!
//    @IBOutlet weak var swipeViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var detailCommonView: UIView!
//    @IBOutlet weak var tabStackView: UIStackView!
//    @IBOutlet weak var businessCity: DesignableUILabel!
//    @IBOutlet weak var ratingStackView: UIStackView!
//
//
//
//    //MARK: Variables
//    var BusinessData : BusinessResponseData?
//    var businessId = String()
//    var imageSourceArray = [AlamofireSource]()
//    var swipeIndex = 0
//    var sendToSecondVCImageSource = [[[AlamofireSource]]]()
//    var reviewData:[Reviews]?
//    var isLoadingList = false
//    var pagination = 1
//    var productData = [BusinessTraits]()
//    var allCategoriesData = [[BusinessTraits]]()
//    var count = 0
//    var headingString = [String]()
//    var offerData = [PromotionOffer]()
//    var isPresented = false
//    var isTimingViewStretched = false
//    var mainScrollTop = 0.0
//    var isNavigatedFromOffer = false
//    var favoriteData = [ProductData]()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.noDataLabel.isHidden = true
//        self.mainScrollView.delegate = self
//        self.mainScrollTop = self.tabStackView.frame.minY
//        self.reviewTableView.estimatedRowHeight = 210
//        self.reviewTableView.rowHeight = UITableView.automaticDimension
//        self.offersTableView.tableFooterView = UIView()
//        self.reviewTableView.tableFooterView = UIView()
//
//        self.distanceLeadingConstant.constant = self.view.frame.width/2 - 5
//        self.swipeViewHeight.constant = self.view.frame.height > 800 ? self.view.frame.height*0.8:self.view.frame.height*0.9
//
//        categoryCollection.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderFooterClass")
//        navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
//            if(vc.isKind(of: SearchViewController.self)) {
//                return true
//            } else {
//                return false
//            }
//        })
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.swipeView.addGestureRecognizer(swipeRight)
//        self.descriptLabel.numberOfLines = 3
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
//        self.swipeView.addGestureRecognizer(swipeLeft)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
//        categoryCollection?.addGestureRecognizer(tap)
//
//        if(self.isPresented){
//            self.addDismissRecognizer(view: self.view)
//        } else {
//            self.addPopRecognizer(view: self.view)
//        }
//        self.timingLocale.text = "Store timings".localizableString(loc: Singleton.shared.language ?? "en")
//        if(self.isNavigatedFromOffer){
//            self.swipeIndex = 2
//            self.setContainerView()
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.handleDarktheme()
//        self.handleViewAsUser()
//        self.getBusinessDetail()
//        self.setContainerView()
//        self.getMyOffers()
//        self.initializeView(view: self.productView,label: self.productLabel)
//        let view = UIView(frame: CGRect(x: 50, y: 50, width: self.view.frame.size.width, height: 50))
//        view.backgroundColor = UIColor.white
//    }
//
//    func handleDarktheme(){
//        self.view.backgroundColor = Singleton.shared.themeColor == K_DARK_THEME ? K_DARK_GRAY_COLOR : .white
//        self.swipeView.backgroundColor = Singleton.shared.themeColor == K_DARK_THEME ? K_DARK_GRAY_COLOR : K_BACKGROUND_COLOR
//    }
//
//    func handleViewAsUser(){
//        if(K_CURRENT_USER == K_VENDOR){
//            self.cartView.isHidden = true
//        }
//    }
//
//    func getSavedWishlist(){
//        SessionManager.shared.methodForApiCalling(url: U_BASE + U_GET_WISHLIST + "0", method: .get, parameter: nil , objectClass: GetFavourite.self, requestCode: U_GET_WISHLIST) { response in
//            self.favoriteData = response.response
//            self.categoryCollection.reloadData()
//        }
//    }
//
//    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
//        let p = gestureRecognizer.location(in: categoryCollection)
//
//        if let index = categoryCollection?.indexPathForItem(at: p) {
//            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleProductViewController" ) as! SingleProductViewController
//            myVC.imageSlideName = "singleStoreImageSlide" + "\(index.section)" + "\(index.row)"
//            myVC.heroId = "singleStorehopName" + "\(index.section)" + "\(index.row)"
//            myVC.productId = self.allCategoriesData[index.section][index.row].id ?? ""
//            myVC.imageSourceArray = self.sendToSecondVCImageSource[index.section][index.row]
//            myVC.modalPresentationStyle = .overFullScreen
//            present(myVC, animated: true, completion: nil)
//        }
//    }
//
//
//    func getReviewAndRatings(){
//        SessionManager.shared.methodForApiCalling(url: U_BASE + U_GET_REVIEWS + businessId, method: .get, parameter: nil, objectClass: GetStoreReview.self , requestCode: U_GET_REVIEWS) { response in
//            self.reviewData = response.response?.reviews
//            self.reviewTableView.reloadData()
//        }
//    }
//
//    func getMyOffers(){
//        SessionManager.shared.methodForApiCalling(url: U_BASE + U_GET_SINGLE_STORE_OFFERS + "\(self.businessId)" , method: .get, parameter: nil, objectClass: GetStorePromotionsResponse.self, requestCode: U_GET_PROMOTION_OFFERS) { response in
//            self.offerData = response.response?.storePromotions  ?? []
//            self.offersTableView.reloadData()
//        }
//    }
//
//    func toggleFavouriteStore(){
//        if((Singleton.shared.userDetail.id ?? "") == ""){
//            self.showErrorMsg(msg: "Please login to continue.".localizableString(loc: Singleton.shared.language ?? "en"), type: 3)
//            return
//        }
//        ActivityIndicator.show(view: self.view)
//        SessionManager.shared.methodForApiCalling(url: U_BASE + U_TOGGLE_FAVOURITE_STORE + businessId, method: .get, parameter: nil, objectClass: GetFavToggleStoreResponse.self , requestCode: U_TOGGLE_FAVOURITE_STORE) { response in
//            ActivityIndicator.hide()
//            if((response.message ?? "") != ""){
//                //                self.showErrorMsg(msg: response.message ?? "")
//            }
//        }
//    }
//
//    func getBusinessDetail(){
//        ActivityIndicator.show(view: self.view)
//        SessionManager.shared.methodForApiCalling(url: U_BASE + U_GET_SINGLE_STORE + businessId + "?page=\(self.pagination)" + "&longitude=\(Singleton.shared.userLocation.coordinate.longitude)" + "&latitude=\(Singleton.shared.userLocation.coordinate.latitude)" , method: .post, parameter: nil, objectClass: GetBusinessResponse.self , requestCode: U_GET_SINGLE_STORE) { response in
//
//            if(self.productData.count == 0 || self.pagination == 1 ){
//                self.productData = response.response?.data ?? []
//                self.isLoadingList = false
//            } else if (response.response?.data?.count ?? 0) > 0{
//                for i in 0..<(response.response?.data?.count ?? 0) {
//                    self.productData.append(response.response?.data?[i] ?? BusinessTraits())
//                }
//                self.isLoadingList = false
//            }
//            if((response.response?.data?.count ?? 0) == 0){
//                if self.pagination > 1 {
//                    self.pagination -= 1
//                }
//                self.isLoadingList = false
//            }
//
//            self.sendToSecondVCImageSource = []
//            self.headingString = []
//            self.allCategoriesData = []
//            self.BusinessData = response.response
//            if(response.response?.business?.business_operating_timings != nil){
//                self.timingTable.reloadData()
//                self.timingLabel.isHidden = true
//                self.timingTable.isHidden = false
//            }else {
//                self.timingLabel.text = "Delivery timing not added"
//                self.timingLabel.isHidden = false
//                self.timingTable.isHidden = true
//            }
//
//            let newly = response.response?.newlyAdded ?? []
//            let featured = response.response?.featured ?? []
//            let top = response.response?.topSeller ?? []
//            let shopProduct = self.productData
//
//            var newlySource = [[AlamofireSource]]()
//
//            for i in newly {
//                var imageS = [AlamofireSource]()
//                if((i.variants?.count ?? 0) > 0){
//                    let some = i.variants![0]
//                    switch some.attributes?["images"] {
//                    case .arrString(let image):
//                        for i in 0..<(image.count){
//                            if(image[i].contains("http")){
//                                imageS.append(AlamofireSource(urlString:(image[i]))!)
//                            }else {
//                                imageS.append(AlamofireSource(urlString: U_IMAGE_BASE + (image[i]))!)
//                            }
//                        }
//                        break
//                    default:
//                        break
//                    }
//                }
//                newlySource.append(imageS)
//            }
//
//
//            var featuredSource = [[AlamofireSource]]()
//
//            for i in featured {
//                var imageS = [AlamofireSource]()
//                if((i.variants?.count ?? 0) > 0){
//                    let some = i.variants![0]
//                    switch some.attributes?["images"] {
//                    case .arrString(let image):
//                        for i in 0..<(image.count){
//                            if(image[i].contains("http")){
//                                imageS.append(AlamofireSource(urlString:(image[i]))!)
//                            }else {
//                                imageS.append(AlamofireSource(urlString: U_IMAGE_BASE + (image[i]))!)
//                            }
//                        }
//                        break
//                    default:
//                        break
//                    }
//                }
//                featuredSource.append(imageS)
//            }
//
//
//            var topSource = [[AlamofireSource]]()
//            for i in top {
//                var imageS = [AlamofireSource]()
//                if((i.variants?.count ?? 0) > 0){
//                    let some = i.variants![0]
//                    switch some.attributes?["images"] {
//                    case .arrString(let image):
//                        for i in 0..<(image.count){
//                            if(image[i].contains("http")){
//                                imageS.append(AlamofireSource(urlString:(image[i]))!)
//                            }else {
//                                imageS.append(AlamofireSource(urlString: U_IMAGE_BASE + (image[i]))!)
//                            }
//                        }
//                        break
//                    default:
//                        break
//                    }
//                }
//                topSource.append(imageS)
//            }
//
//            var shopSource = [[AlamofireSource]]()
//            for i in shopProduct {
//                var imageS = [AlamofireSource]()
//                if((i.variants?.count ?? 0) > 0){
//                    let some = i.variants![0]
//                    switch some.attributes?["images"] {
//                    case .arrString(let image):
//                        for i in 0..<(image.count){
//                            if(image[i].contains("http")){
//                                imageS.append(AlamofireSource(urlString:(image[i]))!)
//                            }else {
//                                imageS.append(AlamofireSource(urlString: U_IMAGE_BASE + (image[i]))!)
//                            }
//                        }
//                        break
//                    default:
//                        break
//                    }
//                }
//                shopSource.append(imageS)
//            }
//
//
//            if newly.count > 0 {
//                self.allCategoriesData.append(newly)
//                self.headingString.append("Newly Added".localizableString(loc: Singleton.shared.language ?? "en"))
//                self.sendToSecondVCImageSource.append(newlySource)
//            }
//
//            if featured.count > 0 {
//                self.allCategoriesData.append(featured)
//                self.headingString.append("Featured Products".localizableString(loc: Singleton.shared.language ?? "en"))
//                self.sendToSecondVCImageSource.append(featuredSource)
//            }
//
//            if top.count > 0 {
//                self.allCategoriesData.append(top)
//                self.headingString.append("Top Products".localizableString(loc: Singleton.shared.language ?? "en"))
//                self.sendToSecondVCImageSource.append(topSource)
//            }
//
//            if shopProduct.count > 0 {
//                self.allCategoriesData.append(shopProduct)
//                self.headingString.append("All Products".localizableString(loc: Singleton.shared.language ?? "en"))
//                self.sendToSecondVCImageSource.append(shopSource)
//            }
//
//            self.setBusinessDetail()
//            self.getReviewAndRatings()
//            self.setContainerView()
//
//            if (self.BusinessData?.business?.achievements?.count ?? 0) > 0 {
//                self.achievementsCollectionView.isHidden = false
//            } else {
//                self.achievementsCollectionView.isHidden = true
//            }
//            self.achievementsCollectionView.reloadData()
//            ActivityIndicator.hide()
//            if(Singleton.shared.userDetail.id != nil){
//                self.getSavedWishlist()
//            }else {
//                self.categoryCollection.reloadData()
//            }
//
//        }
//    }
//
//    func setBusinessDetail() {
//        if (self.BusinessData?.business?.isFavourite ?? false == true) {
//            self.heartIcon.changeTint(color: K_PURPLE_COLOR)
//            self.heartIcon.image = UIImage(named: "heart")
//            self.markFavouriteLabel.text = "Unmark Fav"
//        } else {
//            self.heartIcon.image = UIImage(named: "heart-1")
//            self.markFavouriteLabel.text = "Mark Fav"
//        }
//        self.cosmosView.rating = self.BusinessData?.business?.rating ?? 0.0
//        self.reviewCosmosView.rating = self.BusinessData?.business?.rating ?? 0.0
//        self.cosmosView.isUserInteractionEnabled = false
//
//        self.reviewCosmosView.isUserInteractionEnabled = false
//        self.BusniessName.text = self.BusinessData?.business?.businessName ?? ""
//        self.businessCity.text = self.BusinessData?.business?.businessCity ?? ""
//        if((self.BusinessData?.business?.logo ?? "").contains("http")){
//            self.businessLogo.pin_setImage(from: URL(string: "\(self.BusinessData?.business?.logo ?? "")"))
//        }else {
//            self.businessLogo.pin_setImage(from: URL(string: U_IMAGE_BASE + "\(self.BusinessData?.business?.logo ?? "")"))
//        }
//        if((self.BusinessData?.business?.banner ?? "").contains("http")){
//            self.backgroundImage.pin_setImage(from: URL(string: "\(self.BusinessData?.business?.banner ?? "")"))
//        }else {
//            self.backgroundImage.pin_setImage(from: URL(string: U_IMAGE_BASE + "\(self.BusinessData?.business?.banner ?? "")"))
//        }
//
//        self.rateLabel.text = (self.BusinessData?.business?.rating ?? 0 == 0) ? "0": "\(self.BusinessData?.business?.rating ?? 0)"
//       // self.ratingStackView.isHidden = (self.BusinessData?.business?.rating ?? 0 == 0)
//
//        self.noOfReviews.text = "\((self.BusinessData?.business?.reviews?.count ?? 0) == 0 ? "No reviews": "\(self.BusinessData?.business?.reviews?.count ?? 0) Reviews") "
//        self.reviewTotalCount.text = (self.BusinessData?.business?.reviews?.count ?? 0 == 0) ? "No reviews yet":"\(self.BusinessData?.business?.rating ?? 0) " + " out of 5"
//        if(self.BusinessData?.business?.distance?.distance ?? "" == "0.0"){
//            self.distanceView.isHidden = true
//        }else {
//            self.distanceView.isHidden = false
//            self.distanceLabel.text = "\(self.BusinessData?.business?.distance?.distance ?? "") " + "kms".localizableString(loc: Singleton.shared.language ?? "en")
//        }
//        self.descriptLabel.text = self.BusinessData?.business?.overview ?? ""
//        self.descriptLabel.adjustsFontSizeToFitWidth = false
//        self.descriptLabel.sizeToFit()
//        let line = self.descriptLabel.calculateMaxLines(width: self.view.frame.size.width - 70)
//        self.topView.translatesAutoresizingMaskIntoConstraints = false
//        self.topView.layer.masksToBounds = false
//        self.downArrowImage.image = UIImage(named: "chevron_down")
//        if(line <= 3){
//            self.downArrowImage.image = UIImage(named: "")
//            self.aboutView.layoutIfNeeded()
//            self.gradientBgView.image = UIImage(named: "")
//            self.gradientView.isHidden = true
//            // self.gradientView.backgroundColor = .white
//        }else {
//            self.descriptLabel.numberOfLines = 3
//            self.gradientBgView.image = UIImage(named: "bgView")
//            self.downArrowImage.image = UIImage(named: "chevron_down")
//            self.gradientView.isHidden = false
//            // self.gradientView.backgroundColor = .clear
//        }
//        self.downArrowImage.image = UIImage(named: "chevron_down")
//        self.timingImage.image = UIImage(named: "chevron_down")
//
//        if(self.BusinessData?.business?.deliveryAllowed == true){
//            self.delvierylabel.text = "Delivery is available in listed cities:"
//            self.cityTable.reloadData()
//        }
//
//        if(self.BusinessData?.business?.pickupAllowed == true){
//            self.delvierylabel.text = (self.delvierylabel.text ?? "") != "" ? ("Pickup allowed for the products in \(self.BusinessData?.business?.businessCity ?? "").\n" + (self.delvierylabel.text ?? "")):"Pickup allowed for the products in \(self.BusinessData?.business?.businessCity ?? "")."
//        }
//    }
//
//    func initializeView(view: UIView, label:UILabel){
//        self.productView.backgroundColor = .clear
//        self.overviewView.backgroundColor = .clear
//        self.reviewsView.backgroundColor = .clear
//        self.offersView.backgroundColor = .clear
//
//        self.productLabel.textColor = K_LIGHT_GRAY
//        self.overviewLabel.textColor = K_LIGHT_GRAY
//        self.offersLabel.textColor = K_LIGHT_GRAY
//        self.favouriteLabel.textColor = K_LIGHT_GRAY
//
//        self.deliveryOptionHeading.text = "Service details"
//        self.pickupLabel.text = "Pickup".localizableString(loc: Singleton.shared.language ?? "en")
//        self.quickDeliveryLabel.text = "Quick delivery (within 3 hours)".localizableString(loc: Singleton.shared.language ?? "en")
//        self.additionallyChargeLabel.placeholder = "Additional charges (if any)".localizableString(loc: Singleton.shared.language ?? "en")
//
//        label.textColor = Singleton.shared.themeColor == K_DARK_THEME ?  .white : K_BLACK_COLOR
//        view.backgroundColor = Singleton.shared.themeColor == K_DARK_THEME ?  .white : K_PURPLE_COLOR
//    }
//
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizer.Direction.right:
//                if self.swipeIndex >= 0 {
//                    self.swipeIndex -= 1
//                    self.setContainerView()
//                }
//            case UISwipeGestureRecognizer.Direction.left:
//                if self.swipeIndex < 4 {
//                    self.swipeIndex += 1
//                    self.setContainerView()
//                }
//            default:
//                break
//            }
//        }
//    }
//
//    func setContainerView() {
//        self.noDataLabel.isHidden = true
//        if self.swipeIndex == 0 {
//            self.initializeView(view: self.productView, label: self.productLabel)
//            self.overViewView.isHidden = true
//            self.categoryCollection.isHidden  = false
//            self.reviewStackView.isHidden = true
//            self.offersTableView.isHidden = true
//            //self.swipeViewHeight.constant = self.categoryCollection.collectionViewLayout.collectionViewContentSize.height
//        } else if self.swipeIndex == 1{
//            self.initializeView(view: self.overviewView, label: self.overviewLabel)
//            self.overViewView.isHidden = false
//            self.categoryCollection.isHidden  = true
//            self.reviewStackView.isHidden = true
//            self.offersTableView.isHidden = true
//            // self.swipeViewHeight.constant = self.view.frame.height > 800 ? self.view.frame.height*0.8:self.view.frame.height*0.9
//        } else if self.swipeIndex == 2 {
//            self.initializeView(view: self.offersView, label: self.offersLabel)
//            self.overViewView.isHidden = true
//            self.categoryCollection.isHidden  = true
//            self.reviewStackView.isHidden = true
//            self.offersTableView.isHidden = false
//            self.offersTableView.reloadData()
//            // self.swipeViewHeight.constant = self.view.frame.height > 800 ? self.view.frame.height*0.8:self.view.frame.height*0.9
//        } else if self.swipeIndex == 3 {
//            self.initializeView(view: self.reviewsView, label: self.favouriteLabel)
//            self.overViewView.isHidden = true
//            self.categoryCollection.isHidden  = true
//            self.reviewStackView.isHidden = false
//            self.offersTableView.isHidden = true
//            self.reviewTableView.reloadData()
//            //  self.swipeViewHeight.constant = self.view.frame.height > 800 ? self.view.frame.height*0.8:self.view.frame.height*0.9
//        }
//        self.productLabel.text = "Products"
//    }
//
//    func openMap() {
//        let latitude: CLLocationDegrees =  Double(self.BusinessData?.business?.businessLatitude ?? "") ?? 0.0
//        let longitude: CLLocationDegrees =   Double(self.BusinessData?.business?.businessLongitude ?? "") ?? 0.0
//
//        let regionDistance: CLLocationDistance = 10000
//        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//        ]
//        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "\(self.BusinessData?.business?.businessName ?? "")"
//        mapItem.openInMaps(launchOptions: options)
//    }
//
//    //MARK: IBActions
//    @IBAction func aboutUsAction(_ sender: Any) {
//        if(self.descriptLabel.numberOfLines == self.descriptLabel.calculateMaxLines(width: self.view.frame.size.width - 70)){
//            self.descriptLabel.numberOfLines = 3
//            self.downArrowImage.image = UIImage(named: "chevron_down")
//            self.descriptLabel.adjustsFontSizeToFitWidth = false
//            self.descriptLabel.sizeToFit()
//            self.aboutView.layoutIfNeeded()
//            self.gradientBgView.image = UIImage(named: "bgView")
//            self.gradientView.backgroundColor = .lightGray.withAlphaComponent(0.3)
//            // self.gradientView.backgroundColor = .white
//        }else {
//            self.descriptLabel.numberOfLines = self.descriptLabel.calculateMaxLines(width: self.view.frame.size.width - 70)
//            self.downArrowImage.image = UIImage(named: "chevron_up")
//            self.descriptLabel.adjustsFontSizeToFitWidth = false
//            self.descriptLabel.sizeToFit()
//            self.aboutView.layoutIfNeeded()
//            self.gradientBgView.image = UIImage(named: "")
//            self.gradientView.backgroundColor = .clear
//            // self.gradientView.backgroundColor = .clear
//        }
//    }
//
//    @IBAction func productAction(_ sender: UIButton) {
//        if(sender.tag == 1){
//            self.swipeIndex = 0
//        }else if(sender.tag == 2){
//            self.swipeIndex = 1
//        }else if(sender.tag == 3){
//            self.swipeIndex = 2
//        }else if(sender.tag == 4){
//            self.swipeIndex = 3
//        }
//        self.setContainerView()
//    }
//
//    @IBAction func favouriteStoreAction(_ sender: Any) {
//        if(Singleton.shared.userDetail.id == nil){
//            self.showErrorMsg(msg: "Please login to continue", type: 3)
//        }else {
//            if(K_CURRENT_USER == K_CUSTOMER){
//                self.toggleFavouriteStore()
//                self.heartIcon.changeTint(color: K_PURPLE_COLOR)
//                if self.heartIcon.image == UIImage(named: "heart") {
//                    self.heartIcon.image = UIImage(named: "heart-1")
//                    self.markFavouriteLabel.text = "Mark Fav"
//                } else {
//                    self.markFavouriteLabel.text = "Unmark Fav"
//                    self.heartIcon.image = UIImage(named: "heart")
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self.heartIcon.transform = self.heartIcon.transform.scaledBy(x: 0.8, y: 0.8)
//                    }, completion: { _ in
//                        UIView.animate(withDuration: 0.2, animations: {
//                            self.heartIcon.transform = CGAffineTransform.identity
//                        })
//                    })
//                }} else {
//                    showErrorMsg(msg: "Cannot perform this action while viewing store as user", type: 3)
//                }
//        }
//    }
//
//
//
//
//    @IBAction func backAction(_ sender: Any) {
//        if(isPresented){
//            self.dismiss(animated: true)
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
//    @IBAction func locationAction(_ sender: Any) {
//        self.openMap()
//    }
//
//    @IBAction func chatAction(_ sender: Any) {
//        if(K_CURRENT_USER == K_CUSTOMER){
//            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//            myVC.customerId =  self.BusinessData?.business?.user ?? ""
//            myVC.logoImage = self.BusinessData?.business?.logo ?? ""
//            myVC.fullName = self.BusinessData?.business?.businessName ?? ""
//            self.present(myVC, animated: true, completion: nil)
//        } else {
//            showErrorMsg(msg: "Cannot perform this action while viewing store as user", type: 3)
//        }
//    }
//
//    @IBAction func goToReviewTab(_ sender: Any) {
//        self.swipeIndex = 3
//        self.setContainerView()
//    }
//
//    @IBAction func timingAction(_ sender: Any) {
//        self.isTimingViewStretched = !self.isTimingViewStretched
//        if(self.isTimingViewStretched){
//            self.timingImage.image = UIImage(named: "chevron_up")
//        }else {
//            self.timingImage.image = UIImage(named: "chevron_down")
//        }
//        self.timingTable.reloadData()
//    }
//
//}
//
//extension SingleStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == self.categoryCollection {
//            return CGSize(width: self.categoryCollection.frame.size.width, height: 50)
//        }
//        return CGSize()
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//        let newView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderFooterClass", for: indexPath) as! MyHeaderFooterClass
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderFooterClass", for: indexPath) as! MyHeaderFooterClass
//            headerView.titleLabel.text = " " + self.headingString[indexPath.section]
//           // headerView.titleLabel.textAlignment = .center
//            headerView.translatesAutoresizingMaskIntoConstraints = false
//            headerView.titleLabel.textColor = self.getThemeTextColor()
//            headerView.titleLabel.frame = CGRect(x: 0, y: 10, width: collectionView.frame.size.width, height: 35)
//            headerView.titleLabel.font = UIFont(name: "WorkSans-SemiBold", size: 16)
//            headerView.backgroundColor = Singleton.shared.themeColor == K_DARK_THEME ? K_DARK_GRAY_COLOR : K_BACKGROUND_COLOR
//
////            if(indexPath.section != 0){
////                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
////                let border = CALayer()
////                border.backgroundColor = UIColor.black.withAlphaComponent(1).cgColor
////                        border.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: 1)
////                self.view.layer.addSublayer(border)
////                headerView.addSubview(view)
////            }
//            return headerView
//        default:
//            assert(false, "Unexpected element kind")
//        }
//        return newView
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if(collectionView == self.categoryCollection){
//            return self.headingString.count
//        }
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.categoryCollection {
//            return self.allCategoriesData[section].count
//        }else if(collectionView == self.cityTable){
//            self.cityTableHeight.constant = Double((self.BusinessData?.business?.serviceRegions?.count ?? 0)/2) * 25 + 25
//            return   self.BusinessData?.business?.serviceRegions?.count ?? 0
//        } else if collectionView == self.achievementsCollectionView {
//            if((self.BusinessData?.business?.achievements?.count ?? 0)%2 == 0){
//                self.collectionHeight.constant = Double((self.BusinessData?.business?.achievements?.count ?? 0)/2) * 35
//            } else {
//                self.collectionHeight.constant = Double((self.BusinessData?.business?.achievements?.count ?? 0)/2) * 35 + 35
//            }
//            return self.BusinessData?.business?.achievements?.count ?? 0
//        }
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
//        if collectionView == self.categoryCollection {
//            let val = self.allCategoriesData[indexPath.section][indexPath.item]
//            cell.contentView.backgroundColor = .clear
//            cell.imageSlide.backgroundColor = self.getThemeViewColor()
//            cell.imageSlide.layer.cornerRadius = 15
//            cell.imageSlide.heroID = "singleStoreImageSlide" + "\(indexPath.section)" + "\(indexPath.row)"
//            cell.shopName.heroID = "singleStoreShopName" + "\(indexPath.section)" + "\(indexPath.row)"
//            cell.imageSlide.slideshowInterval = 3
//            cell.imageSlide.draggingEnabled = true
//            cell.imageSlide.contentScaleMode = UIView.ContentMode.scaleAspectFill
//            let pageIndicator = UIPageControl()
//            pageIndicator.currentPageIndicatorTintColor = UIColor(red: 113/255, green: 60/255, blue: 117/255, alpha: 1)
//            pageIndicator.pageIndicatorTintColor = UIColor.gray
//            cell.imageSlide.pageIndicator = pageIndicator
//            cell.shopName.text = val.name ?? ""
//
//            if((val.variants?.count ?? 0) > 0){
//                let some = val.variants![0]
//                cell.shopPrice.text = "SAR \("\(some.price ?? 0)".addComma)"
//                cell.percentView.isHidden = (some.discountPercent ?? 0) > 0 ? false:true
//                cell.percentLabel.setTitle("\(Int(some.discountPercent ?? 0))%", for: .normal)
//                if(some.actualPrice ?? 0 > 0 && ((some.actualPrice ?? 0) != (some.price ?? 0))){
//                    let myAttribute = [NSAttributedString.Key.foregroundColor: K_DARK_GRAY_COLOR, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: 10)] as [NSAttributedString.Key : Any]
//                    cell.actualPrice.attributedText = NSAttributedString(string: "SAR \("\(some.actualPrice ?? 0)".addComma)",attributes: myAttribute)
//                    cell.actualPrice.isHidden = false
//                }else {
//                    cell.actualPrice.isHidden = true
//                }
//
//                imageSourceArray = []
//                switch some.attributes?["images"] {
//                case .arrString(let image):
//                    for i in 0..<(image.count){
//                        if(image[i].contains("http")){
//                            self.imageSourceArray.append(AlamofireSource(urlString:(image[i]))!)
//                        }else {
//                            self.imageSourceArray.append(AlamofireSource(urlString: U_IMAGE_BASE + (image[i]))!)
//                        }
//                    }
//                    break
//                default:
//                    break
//                }
//            }
//            cell.imageSlide.setImageInputs(imageSourceArray)
//            self.favouriteViewHeight.constant = 40
//            if(Singleton.shared.userDetail.id == nil){
//                cell.heartIconColorView.isHidden = true
//            }else {
//                cell.heartIconColorView.isHidden = false
//            }
//            cell.heartIconColorView.backgroundColor = UIColor.white
//            let favoriteCount = self.favoriteData.filter({$0.id == val.id})
//            if (favoriteCount.count > 0){
//                cell.heartIcon.image = UIImage(named: "heart")
//                cell.heartIcon.changeTint(color: Singleton.shared.themeColor == K_DARK_THEME ? K_BLACK_COLOR : K_PURPLE_COLOR)
//                self.markFavouriteLabel.text = "Unmark Fav"
//            } else {
//                cell.heartIcon.image = UIImage(named: "heart_outline")
//                cell.heartIcon.changeTint(color: K_BLACK_COLOR)
//                self.markFavouriteLabel.text = "Mark Fav"
//            }
//
//
//            cell.heartButton = {
//                if(Singleton.shared.userDetail.id == nil){
//                    self.showErrorMsg(msg: "Please login to continue", type: 3)
//                }else {
//                    if(K_CURRENT_USER == K_CUSTOMER){
//                        self.toggleFavourite(proId: val.id ?? "")
//                        self.getBusinessDetail()
//                    } else {
//                        self.showErrorMsg(msg: "Cannot perform this action while viewing store as user", type: 3)
//                    }
//                }
//            }
//        }else if(collectionView == self.cityTable){
//            if let region = self.BusinessData?.business?.serviceRegions?[indexPath.item] {
//                cell.totalReview.text =   (region.regionName ?? "")
//            }
//        }else if collectionView == self.achievementsCollectionView{
//            cell.totalReview.text = self.BusinessData?.business?.achievements?[indexPath.item] ?? ""
//        }
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.categoryCollection {
//            let width = (collectionView.frame.size.width/2)-10
//            return CGSize(width: width, height: width + 50)
//        } else  if collectionView == self.achievementsCollectionView {
//            return CGSize(width: (collectionView.frame.size.width/2)-20, height: 30)
//        }else  if collectionView == self.cityTable {
//            if let region = self.BusinessData?.business?.serviceRegions?[indexPath.item] {
//                let val = (region.regionName ?? "")
//                let label = UILabel()
//                label.text = val
//                label.sizeToFit()
//                return CGSize(width: label.intrinsicContentSize.width  + 15, height: 25)
//            }
//            return CGSize(width: 0, height: 0)
//        }
//        return CGSize(width: 0, height: 0)
//    }
//}
//
//extension SingleStoreViewController : UITableViewDelegate , UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(tableView == self.reviewTableView){
//            self.noDataLabel.isHidden = true
//            self.noDataLabel.text = "No offers found!"
//            return self.reviewData?.count ?? 0
//        }else if(tableView == self.timingTable){
//            return self.isTimingViewStretched == false ? 1:self.BusinessData?.business?.business_operating_timings?.count ?? 0
//        } else {
//            if(self.swipeIndex == 2){
//                self.noDataLabel.isHidden = self.offerData.count > 0 ? true : false
//            }
//            self.noDataLabel.text = "No offers found!"
//            return self.offerData.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(tableView == self.reviewTableView){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableCell") as! AddressTableCell
//            // cell.contentView.backgroundColor = self.getThemeViewColor()
//            cell.addressLabel.text = self.convertTimestampToDate((self.reviewData?[indexPath.row].updatedAt ?? 0), to: "MMM dd, yyyy") + " at " + self.convertTimestampToDate((self.reviewData?[indexPath.row].updatedAt ?? 0), to: "h:mm a")
//            cell.streetLabel.text = self.reviewData?[indexPath.row].user?.fullName ?? ""
//            if((self.reviewData?[indexPath.row].user?.profile ?? "").contains("http")){
//                cell.tickImage.pin_setImage(from: URL(string: "\(self.reviewData?[indexPath.row].user?.profile ?? "")"))
//            }else {
//                cell.tickImage.pin_setImage(from: URL(string: U_IMAGE_BASE + "\(self.reviewData?[indexPath.row].user?.profile ?? "")"))
//            }
//            cell.deliveredByLabel.text = self.reviewData?[indexPath.row].message ?? ""
//            cell.cosmosView.rating = self.reviewData?[indexPath.row].score ?? 0.0
//            cell.cosmosView.isUserInteractionEnabled = false
//
//            cell.dateLabel.text = self.convertTimestampToDate(self.reviewData?[indexPath.row].createdAt ?? 0, to: "MMM dd, yyyy")
//            return cell
//        }else if(tableView == self.timingTable){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableCell") as! AddressTableCell
//            let val = self.BusinessData?.business?.business_operating_timings![indexPath.row]
//            if(self.isTimingViewStretched == false){
//                let currentDay = self.convertTimestampToDate(Int(Date().timeIntervalSince1970), to: "EEEE").lowercased()
//                let current = self.BusinessData?.business?.business_operating_timings?.filter{$0.day?.lowercased() == currentDay}
//                if((current?.count ?? 0) > 0){
//                    let detail = (current?[0].closed == true ? "Closed": ((current?[0].timing?.from ?? "") + "-" + (current?[0].timing?.to ?? "")))
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyy-MM-dd, h:mm a"
//                    var startTimestamp = ""
//                    if(current?[0].closed == false){
//                        let today1 = self.convertTimestampToDate(Int(Date().timeIntervalSince1970), to: "yyyy-MM-dd") + ", \(current?[0].timing?.from ?? "")"
//                        let today2 = self.convertTimestampToDate(Int(Date().timeIntervalSince1970), to: "yyyy-MM-dd") + ", \(current?[0].timing?.to ?? "")"
//                        let date1 = dateFormatter.date(from: today1)?.timeIntervalSince1970
//                        let date2 = dateFormatter.date(from: today2)?.timeIntervalSince1970
//                        let today = Date().timeIntervalSince1970
//                        startTimestamp = (today > date1! && today < date2!) ? detail:today < date1! ? "Opens soon":"Closed"
//                    }else {
//                        startTimestamp = detail
//                    }
//                    cell.streetLabel.text = (current?[0].day ?? "")
//                    if(current?[0].closed == true){
//                        cell.statusLabel.text = ""
//                        cell.statusLabel.textColor = K_RED_COLOR
//                    }else {
//                        cell.statusLabel.text = ""
//                        cell.statusLabel.textColor = K_GREEN_COLOR
//                    }
//                    cell.dateLabel.text = startTimestamp
//                }
//            }else {
//                let detail = (val?.closed == true ? "Closed": ((val?.timing?.from ?? "") + "-" + (val?.timing?.to ?? "")))
//                cell.streetLabel.text = (val?.day ?? "")
//                if(val?.closed == true){
//                    cell.statusLabel.text = ""
//                    cell.statusLabel.textColor = K_RED_COLOR
//                }else {
//                    cell.statusLabel.text = ""
//                    cell.statusLabel.textColor = K_GREEN_COLOR
//                }
//                cell.dateLabel.text = detail
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableCell") as! OfferTableCell
//            cell.bannerImage.pin_setImage(from: URL(string: "\(self.offerData[indexPath.row].banner ?? "")"))
//            cell.offerDescription.text = self.offerData[indexPath.row].title ?? ""
//            cell.fromDate.text = self.offerData[indexPath.row].offer_start_date ?? ""
//            cell.tillDate.text = self.offerData[indexPath.row].offer_end_date ?? ""
//            cell.offerTitle.text = "Flat \(self.offerData[indexPath.row].offer_percentage ?? "0")% off"
//            //            cell.offerButton = {
//            //                SessionManager.shared.methodForApiCalling(url: U_BASE + U_DELETE_OFFERS + "\(self.offerData[indexPath.row].id ?? "")" , method: .delete, parameter: nil, objectClass: SuccessResponse.self, requestCode: U_DELETE_OFFERS) { response in
//            //                    self.offerData.remove(at: indexPath.row)
//            //                    self.offersTableView.reloadData()
//            //                }
//            //            }
//            return cell
//        }
//    }
//}
//
//
//class QuickCell4: UICollectionViewCell {
//
//    let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureViews()
//    }
//
//    func configureViews() {
//        addSubview(containerView)
//        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class MyHeaderFooterClass: UICollectionReusableView {
//
//    let titleLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.purple
//        addSubview(titleLabel)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        titleLabel.sizeToFit()
//        titleLabel.frame.origin = CGPoint(x: 0, y: 0)
//    }
//}
//
