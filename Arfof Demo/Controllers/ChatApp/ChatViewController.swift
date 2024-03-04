//
//  ChatViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 11/01/24.
//

import UIKit
import NotificationCenter
import SDWebImage
import Firebase
import FirebaseAnalytics

protocol ChatCellDelegate: AnyObject {
    func didTapImage(_ image: UIImage)
}

class ChatViewController: UIViewController , UIScrollViewDelegate{
    
    //MARK: Variables
    var fetchedChatData: [ChatMessage] = []
    var groupedMessages: [String: [ChatMessage]]  = [:]
    var sortedDays: [String] = []
    var receiverUid = ""
    var receiverprofileImageURL : URL?
    var receiverNameData : String?
    var myUid = ""
    var chatId = ""
    var cameFromHome : Bool = false
    var newChatObserver: DatabaseHandle?
    let currentUser = CurrentUserManager.shared.currentUser
    
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var receiverProfileImage: CustomImage!
    @IBOutlet weak var receiverNamelabel: UILabel!
    @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachMsgView: UIView!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var sendMessageImage: UIImageView!
    
    //Background Image display view
    @IBOutlet weak var bgImageView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var sendImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        setScreen()
        hideKeyboardTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                AnalyticsParameterScreenName: "ChatScreen",
                AnalyticsParameterScreenClass: NSStringFromClass(self.classForCoder)
            ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    
    //MARK: IBOutlet Actions
    @IBAction func backButtonAction(_ sender: Any) {
        
        // Remove the observer when navigating away
        if let newChatObserver = newChatObserver {
            let chatRef = Database.database().reference().child("allChat").child(chatId)
            chatRef.removeObserver(withHandle: newChatObserver)
        }
        if cameFromHome{
            self.navigationController?.popViewController(animated: true)
        }else{
            if let controllers = self.navigationController?.viewControllers, controllers.count >= 3 {
                if let HomeViewController = controllers[controllers.count - 3] as? HomeViewController {
                    self.navigationController?.popToViewController(HomeViewController, animated: true) // pop to home view controller
                }
            }
        }
    }
    
    @IBAction func msgSendTapped(_ sender: Any) {
        if let messageText = msgTextField.text {
            saveMessgageToRealtimeDatabase(messageText: messageText, dataType: "text", receiverUid: self.receiverUid, chatId: self.chatId, myUid: self.myUid, myName: self.currentUser?.userName ?? "Arfof", receiverName: receiverNameData ?? "Arfof")
            msgTextField.text = nil // Clear the text field after sending the message
            sendButtonInactive()
        }
    }
    
    //text field msg changed
    @IBAction func msgTextFieldEditingChanged(_ sender: Any) {
        if(msgTextField.text == ""){
            sendButtonInactive()
        }else{
            sendButtonActive()
        }
    }
    
    @IBAction func attachButtonTapped(_ sender: Any) {
        showImagePickerOptions()
    }
    
    //background ImageView Iboutlet actions
    @IBAction func closeImageViewButton(_ sender: Any) {
        closeImageView()
    }
    
    @IBAction func sendImageButtonTapped(_ sender: Any) {
        guard let image = bgImage.image else{return}
        ActivityIndicator.show(view: self.view)
        storeImageInServer(image) { url in
            ActivityIndicator.hide()
            self.closeImageView()
            if let imageURL = url {
                saveMessgageToRealtimeDatabase(messageText: imageURL.absoluteString , dataType: "image", receiverUid: self.receiverUid, chatId: self.chatId, myUid: self.myUid, myName: self.currentUser?.userName ?? "Arfof", receiverName: self.receiverNameData ?? "Arfof")
            } else {
                print("Error in image message.")
            }
        }
    }
    
    //MARK:  @objc FUnctions
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("Keyboard size \(keyboardSize.height)")
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
            textfieldBottomConstraint.constant = -(keyboardSize.height - bottomSafeAreaHeight)
            scrollToLastRow()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        textfieldBottomConstraint.constant = 0
    }
    
    //MARK: Functions
    //screen setup
    func setScreen(){
        receiverProfileImage.sd_setImage(with: receiverprofileImageURL, placeholderImage: UIImage(systemName: "person.circle"))
        receiverNamelabel.text = receiverNameData
        sendButtonInactive()
        createChatID()
    }
    
    //scroll to last row in chat table view
    func scrollToLastRow() {
        guard let lastSection = sortedDays.last else {
            return
        }
        guard let lastRow = groupedMessages[lastSection]?.count, lastRow > 0 else {
            return
        }
        // Scroll to the last row
        let lastIndexPath = IndexPath(row: lastRow - 1, section: sortedDays.count - 1)
        chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
    }
    
    //send button allow or not
    func sendButtonActive(){
        attachMsgView.isHidden = true
        sendMessageImage.tintColor = K_PURPLE_COLOR
        sendButtonView.isUserInteractionEnabled = true
    }
    func sendButtonInactive(){
        attachMsgView.isHidden = false
        sendMessageImage.tintColor = .lightGray
        sendButtonView.isUserInteractionEnabled = false
    }
    
    //MARK: Saving data in firebase
    func createChatID() {
        let databaseSenderRef = Database.database().reference().child("userChatData").child(myUid).child(receiverUid)
        let databaseReceiverRef = Database.database().reference().child("userChatData").child(receiverUid).child(myUid)
        
        self.chatId = [myUid, receiverUid].sorted().joined(separator: "_")
        
        // Check if the chat already exists for the sender
        databaseSenderRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard snapshot.exists() == false else {
                // The chat already exists for the sender
                print("Chat already exists for sender")
                self!.fetchChatFromRealtimeDatabase()
                return
            }
            
            // The chat doesn't exist for the sender, proceed to create
            let senderChat: [String: Any] = [
                "userName": self!.receiverNameData!,
                "userProfile": self!.receiverprofileImageURL!.absoluteString,
                "chatId": self?.chatId ?? "",
                "unreadCount": 0  // Initial unread count is 0
            ]
            databaseSenderRef.setValue(senderChat)
            
            if let currentUser = CurrentUserManager.shared.currentUser {
                // Check if the chat already exists for the receiver
                databaseReceiverRef.observeSingleEvent(of: .value) { [weak self] (receiverSnapshot) in
                    guard receiverSnapshot.exists() == false else {
                        print("Chat already exists for receiver")
                        return
                    }
                    let receiverChatDetail: [String: Any] = [
                        "userName": currentUser.userName,
                        "userProfile": currentUser.profileImageURL!.absoluteString,
                        "chatId": self?.chatId ?? "",
                        "unreadCount": 0
                    ]
                    databaseReceiverRef.setValue(receiverChatDetail) { (_, _) in
                        self?.fetchChatFromRealtimeDatabase()
                    }
                }
            }
        }
    }
    
    //MARK: Fetching Chat from server
    // fetching from realtime database firebase..
    func fetchChatFromRealtimeDatabase() {
        let chatRef = Database.database().reference().child("allChat").child(chatId)
        newChatObserver = chatRef.observe(.childAdded) { [weak self] (snapshot) in
            self?.handleNewChatSnapshot(snapshot)
        }
        //observer to detect deletions in chat.
        chatRef.observe(.childRemoved) { [weak self] (snapshot) in
            self?.handleDeletedChatSnapshot(snapshot)
        }
        //observer to detect changes in chat..
        chatRef.observe(.childChanged) { [weak self] (snapshot) in
            self?.handleChangedChatSnapshot(snapshot)
        }
    }

    private func handleNewChatSnapshot(_ snapshot: DataSnapshot) {
        guard let messageId = snapshot.key as? String,
              let messageData = snapshot.value as? [String: Any],
              let senderId = messageData["senderId"] as? String,
              let receiverId = messageData["receiverId"] as? String,
              let timestamp = messageData["timestamp"] as? Double,
              let data = messageData["data"] as? String,
              let seen = messageData["seen"] as? Bool,
              let dataType = messageData["dataType"] as? String else {
            print("Error parsing chat message.")
            return
        }

        let chatMessage = ChatMessage(messageId: messageId, userId: senderId, receiverId: receiverId, message: data, timestamp: timestamp, dataType: dataType, seen: seen)
        // Group messages by day directly
        let day = chatMessage.day
        if var messagesForDay = groupedMessages[day] {
            messagesForDay.append(chatMessage)
            groupedMessages[day] = messagesForDay
        } else {
            groupedMessages[day] = [chatMessage]
        }
        // Sort the days in ascending order
        sortedDays = groupedMessages.keys.sorted(by: { $0 < $1 })

        // Reload the table view data
        self.chatTableView.reloadData()
        self.scrollToLastRow()

        
        if receiverId == myUid {
            let databaseRef = Database.database().reference()
            let allChatPath = "allChat/\(self.chatId)/\(messageId)"
            databaseRef.child(allChatPath).child("seen").setValue(true)
            // Update the unread count for the receiver
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let receiverRef = "userChatData/\(self.myUid)/\(self.receiverUid)"
                databaseRef.child(receiverRef).child("unreadCount").setValue(0)
                databaseRef.child(receiverRef).child("unreadCount").observeSingleEvent(of: .value){unreadCountValue in
                    print(unreadCountValue)
                }
            }
        }
        
       
    }

    private func handleDeletedChatSnapshot(_ snapshot: DataSnapshot) {
        guard let messageId = snapshot.key as? String else {
            print("Error parsing deleted chat message.")
            return
        }
        // Iterate over sections and rows in groupedMessages
        for (section, messages) in groupedMessages {
            if let index = messages.firstIndex(where: { $0.messageId == messageId }) {
                // Remove the deleted message from the section
                groupedMessages[section]?.remove(at: index)
                
                // If the section becomes empty, remove the section
                if groupedMessages[section]?.isEmpty == true {
                    groupedMessages.removeValue(forKey: section)
                    sortedDays = groupedMessages.keys.sorted(by: { $0 > $1 })
                    chatTableView.reloadData()
                    return
                }
                // Reload the section
                let sectionIndex = sortedDays.firstIndex(of: section) ?? 0
                chatTableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
                return
            }
        }
    }
    
    private func handleChangedChatSnapshot(_ snapshot: DataSnapshot) {
        guard let messageId = snapshot.key as? String,
              let changedData = snapshot.childSnapshot(forPath: "data").value as? String,
              let seen = snapshot.childSnapshot(forPath: "seen").value as? Bool else {
            print("Error parsing changed chat message.")
            return
        }
        
        // Iterate over sections and rows in groupedMessages
        for (section, messages) in groupedMessages {
            if let index = messages.firstIndex(where: { $0.messageId == messageId }) {
                // Update the message content in the section
                groupedMessages[section]?[index].message = changedData
                groupedMessages[section]?[index].seen = seen
                
                // Reload the corresponding cell in the section
                let sectionIndex = sortedDays.firstIndex(of: section) ?? 0
                chatTableView.reloadRows(at: [IndexPath(row: index, section: sectionIndex)], with: .automatic)
                return
            }
        }
    }
}

//MARK: BG View Image
extension ChatViewController{
    func closeImageView() {
        view.sendSubviewToBack(bgImageView)
        bgImageView.backgroundColor = .clear
    }
    
    func openImageView(with image: UIImage ,sendAllow : Bool ) {
        view.bringSubviewToFront(bgImageView)
        bgImageView.backgroundColor = .black
        bgImage.image = image
        if sendAllow{
            sendImageView.isHidden = false
        }else{
            sendImageView.isHidden = true
        }
    }
    
    // Function to upload chat image to Firebase Storage
    func storeImageInServer(_ image: UIImage, completion: @escaping (_ url: URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let uniqueImageID = UUID().uuidString
        let imageFileName = "\(Auth.auth().currentUser!.uid)_chat_image_\(uniqueImageID).jpg"
        let chatImageRef = storageRef.child("chat_images/\(imageFileName)")
        
        // Upload the file to the path "chat_images/{imageFileName}"
        chatImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image: \(String(describing: error))")
                completion(nil)
                return
            }
            chatImageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(String(describing: error))")
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
    }
}

//MARK: Extension imagepicker
extension ChatViewController : UIImagePickerControllerDelegate ,  UINavigationControllerDelegate{
    
    // function to select image for sending as msg
    func showImagePickerOptions(){
        let alertVC = UIAlertController(title: "Send Media", message: nil , preferredStyle: .actionSheet)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            let cameraAction = UIAlertAction(title: "Use camera", style: .default) { action in
                let cameraImagePicker = self.imagePicker(sourceType: .camera)
                cameraImagePicker.delegate = self
                self.present(cameraImagePicker, animated: true)
            }
            alertVC.addAction(cameraAction)
        }else{
            print("Camera is not avaiable..")
        }
        
        let libraryAction = UIAlertAction(title: "Select from library", style: .default) { action in
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.allowsEditing = true
            libraryImagePicker.delegate = self
            
            self.present(libraryImagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        alertVC.view.tintColor = K_PURPLE_COLOR
        self.present(alertVC, animated: true, completion: nil)
    }
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    // Fucntion call after image selected..
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("unable to pick image. ")
            return
        }
        print("Image is selected")
        openImageView(with: image, sendAllow: true)
        //self.userProfile.image = image
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Edit/Delete MSG
extension ChatViewController {
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touch = sender.location(in: self.chatTableView)
            if let indexPath = chatTableView.indexPathForRow(at: touch) {
                showActionSheet(for: indexPath)
            }
        }
    }
    
    func showActionSheet(for indexPath: IndexPath) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            self?.editMessage(at: indexPath)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteMessage(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let day = sortedDays[indexPath.section]
        let messagesForDay = groupedMessages[day] ?? []
        let message = messagesForDay[indexPath.row]
        
        if(message.dataType == "text"){
            alertVC.addAction(editAction)
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        alertVC.view.tintColor = K_PURPLE_COLOR
        present(alertVC, animated: true, completion: nil)
    }
    
    func editMessage(at indexPath: IndexPath) {
        let day = sortedDays[indexPath.section]
        let messagesForDay = groupedMessages[day] ?? []
        var messageToEdit = messagesForDay[indexPath.row]
        
        let editAlert = UIAlertController(title: "Edit Message", message: nil, preferredStyle: .alert)
        editAlert.addTextField { textField in
            textField.text = messageToEdit.message
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak editAlert] _ in
            guard let newText = editAlert?.textFields?.first?.text else { return }
            messageToEdit.message = newText
            
            // Update the message content in the Firebase Realtime Database
            let databaseRef = Database.database().reference()
            let allChatPath = "allChat/\(self!.chatId)/\(messageToEdit.messageId)"
            databaseRef.child(allChatPath).child("data").setValue(newText)
            
            // Reload the corresponding cell in the chat TableView
            self?.groupedMessages[day]?[indexPath.row].message = messageToEdit.message
            self?.chatTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        editAlert.addAction(saveAction)
        editAlert.addAction(cancelAction)
        
        present(editAlert, animated: true, completion: nil)
    }
    
    func deleteMessage(at indexPath: IndexPath) {
        let day = sortedDays[indexPath.section]
        var messagesForDay = groupedMessages[day] ?? []
        let messageToDelete = messagesForDay[indexPath.row]
        
        let confirmDeleteAlert = UIAlertController(title: "Delete Message", message: "Are you sure you want to delete this message?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            messagesForDay.remove(at: indexPath.row)
            self?.groupedMessages[day] = messagesForDay
            self?.chatTableView.deleteRows(at: [indexPath], with: .automatic)
            // Delete the message from the Firebase Realtime Database
            let databaseRef = Database.database().reference()
            let allChatPath = "allChat/\(self!.chatId)/\(messageToDelete.messageId)"
            databaseRef.child(allChatPath).removeValue()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        confirmDeleteAlert.addAction(deleteAction)
        confirmDeleteAlert.addAction(cancelAction)
        present(confirmDeleteAlert, animated: true, completion: nil)
    }
}


//MARK: Chat TableView Extension
extension ChatViewController : UITableViewDelegate, UITableViewDataSource ,ChatCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = sortedDays[section]
        return groupedMessages[day]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderViewGenerator.generateHeaderView(title: sortedDays[section])
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = sortedDays[indexPath.section]
        let messagesForDay = groupedMessages[day] ?? []
        let message = messagesForDay[indexPath.row]
        
        let isSameUserAsNext: Bool
        
        if indexPath.row < messagesForDay.count - 1 {
            let nextMessage = messagesForDay[indexPath.row + 1]
            isSameUserAsNext = message.userId == nextMessage.userId
        } else {
            // Last message, no Next message to compare
            isSameUserAsNext = false
        }
        if message.userId == myUid {
            if message.dataType == "text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyMsgCell", for: indexPath) as! MyMsgCell
                cell.msgData.text = message.message
                cell.msgTime.text = formattedTimeFromTimestamp(message.timestamp)
                cell.msgTimeSeenViewHeight.constant = isSameUserAsNext ? 0 : 20
                cell.doubleTickImage.tintColor = message.seen ? K_PURPLE_COLOR : .lightGray
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
                longPress.minimumPressDuration = 1
                cell.addGestureRecognizer(longPress)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyImageMsgCell", for: indexPath) as! MyImageMsgCell
                cell.delegate = self
                let imageURL = URL(string: message.message)
                cell.imageData.sd_setImage(with: imageURL , placeholderImage: UIImage(named: "loadingImage"))
                cell.msgTime.text = formattedTimeFromTimestamp(message.timestamp)
                cell.msgTimeSeenViewHeight.constant = isSameUserAsNext ? 0 : 20
                cell.doubleTickImage.tintColor = message.seen ? K_PURPLE_COLOR : .lightGray
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
                longPress.minimumPressDuration = 1
                cell.addGestureRecognizer(longPress)
                return cell
            }
        } else {
            if message.dataType == "text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMsgCell", for: indexPath) as! OtherMsgCell
                cell.msgData.text = message.message
                cell.msgTime.text = formattedTimeFromTimestamp(message.timestamp)
                cell.msgTimeSeenViewHeight.constant = isSameUserAsNext ? 0 : 20
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherImageMsgCell", for: indexPath) as! OtherImageMsgCell
                cell.delegate = self
                let imageURL = URL(string: message.message)
                cell.imageData.sd_setImage(with: imageURL , placeholderImage: UIImage(named: "loadingImage"))
                cell.msgTime.text = formattedTimeFromTimestamp(message.timestamp)
                cell.msgTimeSeenViewHeight.constant = isSameUserAsNext ? 0 : 20
                return cell
            }
        }
    }
    
    //When tap inside ImageCell these will execute
    func didTapImage(_ image: UIImage) {
        openImageView(with: image, sendAllow: false)
    }
}

//MARK: Table Cell
class MyMsgCell : UITableViewCell{
    @IBOutlet weak var msgData: UILabel!
    @IBOutlet weak var msgTime: UILabel!
    @IBOutlet weak var msgTimeSeenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doubleTickImage: UIImageView!
    
}

class OtherMsgCell : UITableViewCell{
    @IBOutlet weak var msgData: UILabel!
    @IBOutlet weak var msgTime: UILabel!
    @IBOutlet weak var msgTimeSeenViewHeight: NSLayoutConstraint!
    
}

class MyImageMsgCell : UITableViewCell{
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var msgTime: UILabel!
    @IBOutlet weak var msgTimeSeenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doubleTickImage: UIImageView!
    
    weak var delegate: ChatCellDelegate?
    var tapGesture: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add tap gesture recognizer to the image view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageData.addGestureRecognizer(tapGesture)
        imageData.isUserInteractionEnabled = true
    }
    @objc func imageTapped() {
        delegate?.didTapImage(imageData.image!)
    }
    
}

class OtherImageMsgCell : UITableViewCell{
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var msgTime: UILabel!
    @IBOutlet weak var msgTimeSeenViewHeight: NSLayoutConstraint!
    
    weak var delegate: ChatCellDelegate?
    var tapGesture: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add tap gesture recognizer to the image view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageData.addGestureRecognizer(tapGesture)
        imageData.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped() {
        delegate?.didTapImage(imageData.image!)
    }
}


