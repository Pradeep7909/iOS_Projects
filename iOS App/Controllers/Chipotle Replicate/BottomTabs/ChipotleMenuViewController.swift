//
//  ChipotleMenuViewController.swift
//  iOS App
//
//  Created by Qualwebs on 21/02/24.
//

import UIKit

class ChipotleMenuViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 100
        
    }
    
    @IBAction func findButtonAction(_ sender: Any) {
        
        let sb = UIStoryboard(name: "TestStoryboard", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ChipotleMapViewController") as? ChipotleMapViewController{
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}

//MARK: TableView
extension ChipotleMenuViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChipotleMenuCell") as! ChipotleMenuCell
        let foodItem = foodMenuArray[indexPath.row]
        cell.foodImage.sd_setImage(with: URL(string: foodItem.image), placeholderImage: UIImage(named: "food-placeholder"))
        cell.foodName.text = foodItem.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didvselect \(indexPath)")
    }
}



class ChipotleMenuCell : UITableViewCell{
   
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    
}
