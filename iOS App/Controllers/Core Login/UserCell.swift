//
//  UserCell.swift
//  iOS App
//
//  Created by Guest on 11/25/23.
//

import UIKit

protocol UserCellDelegate: AnyObject {
    func didTapEditButton(user: UserEntity)
    func didTapDeleteButton(user: UserEntity)
}

class UserCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var viewForProfile: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: UserCellDelegate?
    
    var user: UserEntity? {
        didSet{
            userCongiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupButtons()
        setCell()
    }
    
    func setupButtons() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func editButtonTapped() {
        if let user = user {
            delegate?.didTapEditButton(user: user)
        }
    }
    
    @objc func deleteButtonTapped() {
        if let user = user {
            delegate?.didTapDeleteButton(user: user)
        }
    }
    
    func setCell(){
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        viewForProfile.layer.cornerRadius = 15
        editButton.layer.cornerRadius = 15
        deleteButton.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func userCongiguration(){
        guard let user else {return }
        
        fullNameLabel.text = "Name: \(user.firstName ?? "")  \(user.lastName ?? "")"
        emailLabel.text = "Email: \(user.email ?? "")"
        if(user.imageName != "null"){
            let imageURL = URL.documentsDirectory.appendingPathComponent(user.imageName!).appendingPathExtension("png")
            profileImage.image = UIImage(contentsOfFile: imageURL.path)
        }else {
            profileImage.image = UIImage(systemName: "person.circle")
        }
        numberLabel.text = "Contact Number: \(user.number ?? "")"
    }
}
