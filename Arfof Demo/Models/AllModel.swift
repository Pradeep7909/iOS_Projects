//
//  UserModel.swift
//  Arfof Demo
//
//  Created by Guest on 11/23/23.
//

import Foundation

struct UserModel {
    let firstName : String
    let lastName : String
    let email : String
    let password :  String
    let imageName : String
    let number : String
}

struct ProductDetail{
    let productName :  String
    let productImage : String
    let productPrice : String
}

struct StoreOpenDays{
    let day : String
    let detail : String
}

struct User : Codable {
    var userId: String
    var userName: String
    var aboutUser: String
    var profileImageURL: URL?
    var isOnline: Bool
}

struct ChatMessage {
    let messageId: String
    let userId: String
    let receiverId : String
    var message: String
    var timestamp: Double
    let dataType: String
    var seen: Bool
    
    //computed property to extract the day from the timestamp
    var day: String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM - yyyy"
        return dateFormatter.string(from: date)
    }
}

struct ChatDetail{
    let userId: String
    let chatId: String
}
struct UserChatData{
    let userId: String
    let userName: String
    let profileImageURL: URL?
    var chatId: String
    var lastMessage: String?
    var lastMessageTime: Double
    var dataTpe: String
    var unreadMessageCount: Int = 0
    var isOnline : Bool
}
