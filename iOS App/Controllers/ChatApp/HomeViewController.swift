//
//  HomeViewController.swift
//  iOS App
//
//  Created by Guest on 12/26/23.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController {
        
    var accountHeaderLabel = ""
    var myUid = ""
    public var user: User?
    var recentChats: [UserChatData] = []
    
    
    @IBOutlet weak var userProfileImage: CustomImage!
    @IBOutlet weak var recentChatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNameSaved()
    }
    
    //MARK: IBOutlet ACtions
    @IBAction func moreUsersButtonTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllUsersViewController") as! AllUsersViewController
        controller.myUid = self.myUid
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func profileImageTapped(_ sender: Any) {
        if user != nil{
            print("Navigating to user profile screen")
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.backbtnHide = false
        controller.userprofileImageURL = user?.profileImageURL
        controller.userNameData = user?.userName
        controller.userAboutData = user?.aboutUser ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    //MARK: Functions
    // check user name saved in firebase or not (for checking user is new or old), direct goto profile section
    func checkNameSaved(){
        ActivityIndicator.show(view: self.view)
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            self.myUid = uid

            let databaseRef = Database.database().reference().child("users").child(uid).child("username")
            
            databaseRef.observeSingleEvent(of: .value) { snapshot  in
                ActivityIndicator.hide()
                if let username = snapshot.value as? String {
                    print("old user : \(username)")
                    self.getUserProfileData()
                    self.getRecentChat()
                } else {
                    // name not found
                    print("new user")
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
        }else{
            ActivityIndicator.hide()
        }
    }
    func getUserProfileData() {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let databaseRef = Database.database().reference().child("users").child(uid)
            
            databaseRef.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any],
                      let username = userData["username"] as? String,
                      let aboutUser = userData["aboutUser"] as? String,
                      let profileImageURLString = userData["profileImageURL"] as? String,
                      let profileImageURL = URL(string: profileImageURLString) else {
                    print("Error parsing user data")
                    return
                }
                
                self.user = User(userId: uid, userName: username, aboutUser: aboutUser, profileImageURL: profileImageURL, isOnline: true)
                // Set the current user in the shared manager
                CurrentUserManager.shared.currentUser = self.user
                
                print("Current user data : \(String(describing: self.user))" )
                self.userProfileImage.sd_setImage(with: self.user?.profileImageURL, placeholderImage: UIImage(systemName: "person.circle"))
            }
        } else {
            print("No authenticated user")
        }
    }
    
    //MARK: Fetching RecentChat
    func getRecentChat() {
        let databaseRef = Database.database().reference().child("userChatData").child(myUid)
        databaseRef.observe(.childAdded) { (snapshot) in
            guard let chatData = snapshot.value as? [String: Any],
                  let userId = snapshot.key as? String,
                  let chatId = chatData["chatId"] as? String,
                  let userName = chatData["userName"] as? String,
                  let unreadCount = chatData["unreadCount"] as? Int,
                  let userProfileURLString = chatData["userProfile"] as? String,
                  let userProfileURL = URL(string: userProfileURLString) else {
                print("Error parsing chat data.")
                return
            }

            // Observe changes to isOnline status
            let isOnlineRef = Database.database().reference().child("users").child(userId).child("isOnline")
            isOnlineRef.observe(.value) { (isOnlineSnapshot) in
                let isOnline = isOnlineSnapshot.value as? Bool ?? false

                self.getLastMessage(for: chatId) { lastMessage, lastMsgTime, dataType in
                    // Check if the user is already in recentChats
                    if let existingChatIndex = self.recentChats.firstIndex(where: { $0.userId == userId }) {
                        // Update the existing chat entry with the new last message, last message time, and isOnline status
                        self.recentChats[existingChatIndex].lastMessage = lastMessage
                        self.recentChats[existingChatIndex].lastMessageTime = lastMsgTime!
                        self.recentChats[existingChatIndex].dataTpe = dataType!
                        self.recentChats[existingChatIndex].isOnline = isOnline
                    } else {
                        // If the user is not in recentChats, create a new chat entry
                        let chat = UserChatData(userId: userId, userName: userName, profileImageURL: userProfileURL, chatId: chatId, lastMessage: lastMessage, lastMessageTime: lastMsgTime!, dataTpe: dataType!, unreadMessageCount: unreadCount, isOnline: isOnline)
                        self.recentChats.append(chat)
                    }

                    // Sort the recentChats array based on the timestamp
                    self.recentChats.sort { $0.lastMessageTime > $1.lastMessageTime }
                    self.recentChatTableView.reloadData()
                }
            }
        }
        
        // Add an observer to detect changes in the data
        databaseRef.observe(.childChanged) { [weak self] (snapshot) in
            self?.handleChangedChatSnapshot(snapshot)
        }
    }
    
    private func handleChangedChatSnapshot(_ snapshot: DataSnapshot) {
        guard let receiverID = snapshot.key as? String,
              let chatId = snapshot.childSnapshot(forPath: "chatId").value as? String,
              let unreadCount = snapshot.childSnapshot(forPath: "unreadCount").value as? Int else {
            print("Error parsing unreadcount.")
            return
        }
        if let index = recentChats.firstIndex(where: { $0.chatId == chatId }) {
            recentChats[index].unreadMessageCount = unreadCount
            // Update the UI
            recentChatTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func getLastMessage(for chatId: String, completion: @escaping (String?, Double?, String?) -> Void) {
        let databaseRef = Database.database().reference().child("allChat").child(chatId)
        // Add an observer for child added events
        databaseRef.queryLimited(toLast: 1).observe(.childAdded) { snapshot in
            guard let messageData = snapshot.value as? [String: Any],
                  let messageContent = messageData["data"] as? String,
                  let messagetype = messageData["dataType"] as? String,
                  let timestamp = messageData["timestamp"] as? Double else {
                completion(nil, nil, nil)
                return
            }
            completion(messageContent, timestamp, messagetype)
        }
    }
}

//MARK: TabelViewController
extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = recentChats[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentChatCell") as! RecentChatCell
        cell.userName.text = chat.userName
        cell.userProfileImage.sd_setImage(with: chat.profileImageURL , placeholderImage: UIImage(systemName: "person.circle"))
        if chat.dataTpe == "image"{
            cell.lastMsg.text = "Image : " + chat.lastMessage!
        }else{
            cell.lastMsg.text = chat.lastMessage
        }
        cell.userOnlineView.isHidden = !(chat.isOnline)
        cell.unreadCountView.isHidden = chat.unreadMessageCount == 0 ? true : false
        cell.unreadMsgLabel.text = String(chat.unreadMessageCount)
        cell.lastMsgTime.text = formattedTimeFromTimestamp(chat.lastMessageTime)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = recentChats[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(identifier: "ChatViewController" ) as! ChatViewController
        controller.receiverUid = user.userId
        controller.receiverNameData = user.userName
        controller.receiverprofileImageURL = user.profileImageURL
        controller.myUid = self.myUid
        controller.cameFromHome = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: Table Cell
class RecentChatCell : UITableViewCell{
    
    @IBOutlet weak var userProfileImage: CustomImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastMsg: UILabel!
    @IBOutlet weak var lastMsgTime: UILabel!
    @IBOutlet weak var unreadCountView: CustomView!
    @IBOutlet weak var unreadMsgLabel: UILabel!
    @IBOutlet weak var userOnlineView: CustomView!
    
}
