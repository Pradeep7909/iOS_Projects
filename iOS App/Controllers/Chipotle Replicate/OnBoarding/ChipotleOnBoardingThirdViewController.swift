//
//  ChipotleOnBoardingThirdViewController.swift
//  iOS App
//
//  Created by Qualwebs on 20/02/24.
//

import UIKit
import SDWebImage

class ChipotleOnBoardingThirdViewController: UIViewController {
    
    
    @IBOutlet weak var gifImageView: SDAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gifURL = URL(string: "https://www.geekextreme.com/wp-content/uploads/2012/01/Cute-Animated-Gif-Green-Apple.gif")!
        
        gifImageView.sd_setImage(with: gifURL)
    }
}
