//
//  AllUsersViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 10/01/24.
//

import UIKit
import Firebase
import SDWebImage

class AllUsersViewController: UIViewController {
    
    var users: [User] = []
    var myUid = ""
    var userUIDs: [String] = []
    var allChatIds: [String] = []
    
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var noUserData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllUsersFromRealtimeDatabase()
    }
    
    //MARK: IBoutlet Actions
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Fetch all users' data
    func fetchAllUsersFromRealtimeDatabase() {
        let databaseRef = Database.database().reference().child("users")
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let usersData = snapshot.value as? [String: [String: Any]] else {
                print("Error fetching users")
                return
            }
            // Clear the existing users array before adding new data
            self.users.removeAll()
            
            for (userId, userData) in usersData {
                if userId != self.myUid,  // Exclude the current user
                   let username = userData["username"] as? String,
                   let profileImageURLString = userData["profileImageURL"] as? String,
                   let aboutUser = userData["aboutUser"] as? String,
                   let profileImageURL = URL(string: profileImageURLString) {
                    
                    let user = User(userId: userId, userName: username, aboutUser: aboutUser, profileImageURL: profileImageURL, isOnline: true)
                    self.users.append(user)
                }
            }
            // Sort the users array based on userName
            self.users.sort { $0.userName < $1.userName }
            print("All Users Data :\(self.users)")
            print("Total users :\(self.users.count)")
            if self.users.count != 0{
                self.noUserData.isHidden = true
            }
            // Reload the table view data after fetching users
            self.usersTableView.reloadData()
            
            self.animateTable()
        }
    }
    
    func animateTable() {
        usersTableView.reloadData()
        
        let cells = usersTableView.visibleCells
        let tableWidth = usersTableView.bounds.size.width
        
        // move all cells to the bottom of the screen
        for cell in cells {
          cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
        }
        
        // move all cells from right to the left place
        var index = 0
        for cell in cells {
          UIView.animate(withDuration: 2, delay: 0.1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
          index += 1
        }
      }
}

//MARK: Table Extension
extension AllUsersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableCell") as! AllUsersTableCell
        let user = users[indexPath.row]
        cell.userName.text = user.userName
        cell.userAbout.text = user.aboutUser
        cell.userProfileImage.sd_setImage(with: user.profileImageURL, placeholderImage: UIImage(systemName: "person.circle"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(identifier: "ChatViewController" ) as! ChatViewController
        controller.receiverUid = user.userId
        controller.receiverNameData = user.userName
        controller.receiverprofileImageURL = user.profileImageURL
        controller.myUid = self.myUid
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: Table Cell
class AllUsersTableCell : UITableViewCell{
    
    @IBOutlet weak var userProfileImage: CustomImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAbout: UILabel!
    
}
