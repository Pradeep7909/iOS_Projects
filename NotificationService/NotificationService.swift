//
//  NotificationService.swift
//  NotificationService
//
//  Created by Qualwebs on 03/01/24.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            print("notification service extesnion called and notification modified")
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            bestAttemptContent.categoryIdentifier = "myNotificationCategory"
            
            // Set the person's system image
            if let systemImage = UIImage(systemName: "person.fill") {
                if let imageData = systemImage.pngData() {
                    let fileIdentifier = "personImage.png"
                    if let attachment = saveImageToDisk(fileIdentifier: fileIdentifier, data: imageData, options: nil) {
                        bestAttemptContent.attachments = [attachment]
                    }
                }
            }
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    private func saveImageToDisk(fileIdentifier: String, data: Data, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("Error saving image to disk: \(error)")
        }
        
        return nil
    }
    
}

