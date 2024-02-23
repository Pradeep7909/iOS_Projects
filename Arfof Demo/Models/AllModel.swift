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


struct ClusterAnnotationData{
    let locationName: String
    let subtitle: String
}


struct Product : Codable {
    var id : String?
    var name : String?
}
struct ProductsResponse: Decodable {
    var products: [Product]

    enum CodingKeys: String, CodingKey {
        case products = "response"
    }
}


struct FoodMenu {
    var name : String
    var image : String
}

let foodMenuArray: [FoodMenu] = [
    FoodMenu(name: "Pizza", image: "https://www.pngall.com/wp-content/uploads/2016/05/Pizza-Free-PNG-Image.png"),
    FoodMenu(name: "Burger", image: "https://www.pngall.com/wp-content/uploads/2016/05/Burger-Free-Download-PNG.png"),
    FoodMenu(name: "Pasta", image: "http://pngimg.com/uploads/pasta/pasta_PNG58.png"),
    FoodMenu(name: "Salad", image: "https://www.pngarts.com/files/2/Fruit-Salad-Transparent-Images.png"),
    FoodMenu(name: "Noodles", image: "https://purepng.com/public/uploads/large/purepng.com-noodlenoodlechinesestaple-foodwheat-doughnudel-1411527963191asbjf.png"),
    FoodMenu(name: "Biryani", image: "https://pngbuy.com/wp-content/uploads/2023/06/Veg-biryani-png-400x400.png"),
    
    FoodMenu(name: "Masala Dosa", image: "https://wowjohn.com/wp-content/uploads/2022/05/dosa-png-images-1-Transparent-Images.png"),
    FoodMenu(name: "Chole Bhature", image: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjh05ESvgpgeXFm9YFPNE4Y58ZIw1lVPNNBAesc-YUDc9yZqfBozB8cpC73ZngVgkMsW83h-7jxz3BDWixcqdfjA54uw3xUbaCTexK-1neX_vr-I25UiDc3snB4hRyjppRyaatAFX3yM3xjeri0xar_sjwqn7F9v6ZmggQjsgK1UIMz5j_S51d-A7oc/s478/indian_Chole_%20Bhature.png"),
]

