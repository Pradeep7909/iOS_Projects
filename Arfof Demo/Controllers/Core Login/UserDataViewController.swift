//
//  UserDataViewController.swift
//  Arfof Demo
//
//  Created by Guest on 11/22/23.
//

import UIKit
import CoreData

class UserDataViewController: UIViewController {

    @IBOutlet var myscreen3: UIView!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    private var users: [UserEntity] = []
    private let manager = DatabaseManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        users = manager.fetchUser()
        userTableView.reloadData()
        noDataLabel.isHidden = !users.isEmpty
    }
    
    //MARK: functions
    func navigateToUpdatePage(user: UserEntity){
        guard let navigationToPage = self.storyboard?.instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController else {
            print(" not able to navigate")
            return
        }
        navigationToPage.user = user
        navigationController?.pushViewController(navigationToPage, animated: true)
    }
}


extension UserDataViewController: UITableViewDataSource,UITableViewDelegate, UserCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Total no of users are \(users.count)")
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    func didTapEditButton(user: UserEntity) {
        navigateToUpdatePage(user: user)
    }

    func didTapDeleteButton(user: UserEntity) {
        manager.deleteUser(userEntity: user)
        if let index = users.firstIndex(of: user) {
            users.remove(at: index)
        }
        userTableView.reloadData()
        noDataLabel.isHidden = !users.isEmpty
    }
}


