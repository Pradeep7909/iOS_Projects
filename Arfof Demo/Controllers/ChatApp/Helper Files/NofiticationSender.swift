//
//  NofiticationSender.swift
//  Arfof Demo
//
//  Created by Qualwebs on 17/01/24.
//

import Firebase
import Foundation

// Function to send a notification using FCM
func sendNotification(to fcmToken: String, title: String, body: String, chatId: String, senderId: String, receiverId : String, receiverName: String, messageId: String) {
    print("Notification send function called..")
    let urlString = "https://fcm.googleapis.com/fcm/send"
    guard let url = URL(string: urlString) else { return }

    let headers: [String: String] = [
        "Authorization": "key=AAAAxuJlntE:APA91bHmZp_yPh_ZlR7mLKSBDA5UsdFwKsXB483kX4TYW_TPHU0thkY-Nvt-a7cXaYax8MSJushnLB4930waCojXEjclO8cWovDppK0SQ8gQASaGmG0ua2fO4lv_YroAzmn1CuwdPJrP",
        "Content-Type": "application/json"
    ]
//    let fcmTokens = ["cE1hsX6bxE9dqYRfeJlKjV:APA91bHu2fTQD--d8ScuWl1xCVe1pA6LkJl8wWCmmgcO5uadRsZAZ0q_EJQNqCWwsOdvjRbdDhqFKfrd8P9XcGZBD-hJSenwzDMak6dbKRWFOXnsh0ocUygN2dw0GQMn-p3aYPVcd5ri","e-8M1wEUx0WVmIeFbTMeAz:APA91bFRjYUIWrho2wg35o_t6rI5m1BYQJ-XSUIBx_qe0z0BFMJ21Kc46irZydKB4YHRDWBMCZtgJXU1KWPaqb5kYVgYF-oWjRzlkqtJ-iaQceQJJsTZ41Ec_AL2-BG_9ASXWUZWGSD4", "euEdwF5flEKylvo1UFlvIa:APA91bF1ztMnI5PyebRJfh3iAJXfkBkxkstqxe5JgoPHSEsyo2sp6_BFfjKXZZB_s5vpFJnBbmvmTRiHPg-ieh2LOy2Bpspcqw4TbuoBpJA6C6anr7GBxs_iZSr5xXFYNFU92JJmM7xE"
//    ]

    let notification: [String: Any] = [
        "title": title,
        "body": body,
        "madeBy" : "Pradeep",
        "mutable-content": 1,
        "mutable_content" : true,
        "chatId" : chatId,
        "senderId" : senderId,
        "receiverId" : receiverId,
        "receiverName" : receiverName,
        "messageId" : messageId
    ]
    

    let data: [String: Any] = [
//        "registration_ids": fcmTokens,
        "to": fcmToken,
        "notification": notification
    ]

    print(data)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = try? JSONSerialization.data(withJSONObject: data)

    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error sending notification:", error)
        } else if let data = data {
            let result = try? JSONSerialization.jsonObject(with: data, options: [])
            print("Notification sent successfully:", result ?? "")
        }
    }.resume()
}


