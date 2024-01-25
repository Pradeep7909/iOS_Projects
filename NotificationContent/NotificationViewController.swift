//
//  NotificationViewController.swift
//  CustomNotificationUI
//
//  Created by Qualwebs on 04/01/24.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    //MARK: Variables
    var isSeen = false
    var notification: UNNotification?
    var chatId : String?
    var messageId : String?
    
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationBody: UILabel!
    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var doubleTickImage: UIImageView!
    @IBOutlet weak var markReadLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        
    }
    
    //MARK: IBOutlet Actions
    @IBAction func btn(_ sender: Any) {
        
        print("Button of notification is tapped")
        guard let replyMsg = replyTextField.text else{return}
        
        UIView.animate(withDuration: 0.3) {
            self.preferredContentSize.height = 120
        }
        print(replyMsg)
            
        // Accessing custom data from the notification payload
        guard let chatId = notification?.request.content.userInfo["gcm.notification.chatId"] as? String,
              let messageId = notification?.request.content.userInfo["gcm.notification.messageId"] as? String,
              let myUid = notification?.request.content.userInfo["gcm.notification.receiverId"] as? String,
              let myName = notification?.request.content.userInfo["gcm.notification.receiverName"] as? String,
              let senderId = notification?.request.content.userInfo["gcm.notification.senderId"] as? String else {
            print("parsing failed")
            return}
        
    
        saveMessgageToRealtimeDatabase(messageText: replyMsg, dataType: "text", receiverUid: senderId, chatId: chatId, myUid: myUid, myName: myName, receiverName: notification?.request.content.title ?? "Arfof")
        
        if #available(iOSApplicationExtension 12.0, *) {
               extensionContext?.dismissNotificationContentExtension()
           }

           if let identifier = notification?.request.identifier {
               let center = UNUserNotificationCenter.current()
               center.removeDeliveredNotifications(withIdentifiers: [identifier])
           }
    }
    
    @IBAction func markReadButtonAction(_ sender: Any) {
        if !isSeen{
            doubleTickImage.tintColor = K_PURPLE_COLOR
            markReadLabel.text = "Marked as Read"
            
            guard let chatId = chatId ,
                  let messageId = messageId else{
                print("Data are null")
                return
            }
            let databaseRef = Database.database().reference()
            let allChatPath = "allChat/\(chatId)/\(messageId)"
            databaseRef.child(allChatPath).child("seen").setValue(true)
            
            isSeen = true
        }
    }
    
    
    
    func didReceive(_ notification: UNNotification) {
        self.notification = notification
        self.chatId = notification.request.content.userInfo["gcm.notification.chatId"] as? String
        self.messageId = notification.request.content.userInfo["gcm.notification.messageId"] as? String
        // for custom size of notification...
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 220)
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        
        self.notificationTitle?.text = notification.request.content.title
        self.notificationBody?.text = notification.request.content.body
    }
}




