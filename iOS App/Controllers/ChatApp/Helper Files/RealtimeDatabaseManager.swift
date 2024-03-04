//
//  RealtimeDatabaseManager.swift
//  iOS App
//
//  Created by Qualwebs on 17/01/24.
//

import Foundation
import Firebase

//MARK: Saving Msg to DB
func saveMessgageToRealtimeDatabase(messageText: String, dataType: String, receiverUid : String, chatId : String, myUid : String, myName : String, receiverName: String) {
    
    let databaseRef = Database.database().reference().child("allChat").child(chatId)
    let messageId = databaseRef.childByAutoId().key // Generate a unique message ID
    let messageRef = databaseRef.child(messageId!)
    let messageData: [String: Any] = [
        "senderId": myUid,
        "receiverId": receiverUid,
        "timestamp": ServerValue.timestamp(),
        "data": messageText,
        "dataType": dataType,
        "seen": false
    ]
    
    messageRef.setValue(messageData) { (error, reference) in
        if let error = error {
            print("Error saving message: \(error.localizedDescription)")
        } else {
            print("Message saved successfully with ID: \(String(describing: messageId))")
            // Update the unread count for the receiver
            let databaseReceiverRef = Database.database().reference().child("userChatData").child(receiverUid).child(myUid)
            
            databaseReceiverRef.child("unreadCount").observeSingleEvent(of: .value) { snapshot in
                if let oldCountOfUnreadMessage = snapshot.value as? Int {
                    let newCountOfUnreadMessage = oldCountOfUnreadMessage + 1
                    // Update the value in Firebase
                    databaseReceiverRef.child("unreadCount").setValue(newCountOfUnreadMessage)
                }
            }
            
            //send notification
            let userRef = Database.database().reference().child("users").child(receiverUid)
            userRef.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any],
                      let isOnline = userData["isOnline"] as? Bool,
                let fcmToken = userData["fcmToken"] as? String else{
                    print("Error in parsing receiver Data")
                    return
                }
                let userStatus = isOnline ? "Online" : "Offline"
                print(userStatus)
                print(fcmToken)
                if !isOnline{
                    sendNotification(to: fcmToken, title: myName , body: messageText,chatId : chatId, senderId: myUid,receiverId: receiverUid, receiverName: receiverName, messageId : messageId!)
                    print("Notification is sent because receiver is offline")
                }else{
                    print("Notification is not sent because receiver is Online")
                }
            }
        }
    }
}


//MARK: User OnlineStatus Update
func setOnlineStatus(isOnline: Bool) {
    print("Changing current user status as \(isOnline)")
    if let currentUser = Auth.auth().currentUser {
        let uid = currentUser.uid
        
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.child("isOnline").setValue(isOnline)
        
        // If the user is online, update the last seen timestamp
        if isOnline {
            userRef.child("lastSeen").setValue(ServerValue.timestamp())
        }
    }
}
