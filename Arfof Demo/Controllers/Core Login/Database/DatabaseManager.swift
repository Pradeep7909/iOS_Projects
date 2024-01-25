//
//  DatabaseManager.swift
//  Arfof Demo
//
//  Created by Guest on 11/22/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {

    let context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()

    func addUser(_ user: UserModel) {
        let userEntity = UserEntity(context: context)
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.password = user.password
        userEntity.number = user.number
        userEntity.imageName = user.imageName
        contextSave()
    }

    func fetchUser() -> [UserEntity] {
        var users: [UserEntity] = []
        do {
            users = try context.fetch(UserEntity.fetchRequest())
        } catch {
            print("Error in fetching data: ", error)
        }
        return users
    }

    func updateUser(user: UserModel, userEntity: UserEntity) {
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.password = user.password
        userEntity.number = user.number
        userEntity.imageName = user.imageName

        contextSave()
    }

    func deleteUser(userEntity: UserEntity) {
        let imageURL = URL.documentsDirectory.appendingPathComponent(userEntity.imageName!).appendingPathExtension("png")
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print("Error removing image from storage: ", error)
        }

        context.delete(userEntity)
        contextSave()
    }

    func contextSave() {
        do {
            try context.save()
        } catch {
            print("Error in saving data: ", error)
        }
    }
}

extension URL {
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

