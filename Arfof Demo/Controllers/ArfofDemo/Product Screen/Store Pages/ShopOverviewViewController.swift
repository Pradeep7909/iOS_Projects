//
//  ShopOverviewViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/11/23.
//

import UIKit

class ShopOverviewViewController: UIViewController {
    
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
    
    //MARK: - Outlets
    @IBOutlet weak var storeTimeButtonView: UIView!
    @IBOutlet weak var showButton: UIImageView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGestures()
        setCurrentDay()
    }
    
    //MARK: - Functions
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
}
extension ShopOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreDayCell", for: indexPath)as! StoreDayCell
        
        cell.dayLabel.text = daysToShow[indexPath.item].day
        cell.DetailLabel.text = daysToShow[indexPath.item].detail
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: 20)
    }
    
    
}
