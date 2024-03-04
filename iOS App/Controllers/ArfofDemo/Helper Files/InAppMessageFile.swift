//
//  InAppMessageFile.swift
//  NotificationApp
//
//  Created by Qualwebs on 05/01/24.
//

import Foundation
import UIKit
import FirebaseInAppMessaging

// In CardActionFiamDelegate.swift
class CardActionFiamDelegate: NSObject, InAppMessagingDisplayDelegate {

    // Declare the viewController property
    weak var viewController: UIViewController?

    func messageClicked(_ inAppMessage: InAppMessagingDisplayMessage, with action: InAppMessagingAction) {
        print("messageclicked")

        // Access custom key-value pair from inAppMessage
        if let customData = inAppMessage.appData {
            print(customData)
            for (key, value) in customData {
                print("Custom data - Key: \(key), Value: \(value)")
            }
        }
        
        // Use the viewController to instantiate the ViewController
        if let controller = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as?  ProductViewController{
            
            print("Navigating to product screen")
            
            // Present the ViewController
            viewController?.navigationController?.pushViewController(controller, animated: true)
               

        }
    }

    func messageDismissed(_ inAppMessage: InAppMessagingDisplayMessage,
                          dismissType: FIRInAppMessagingDismissType) {
        // Handle when the in-app message is dismissed
        // The dismissType indicates how the message was dismissed
        // (e.g., by the user, by clicking outside the message, or by timing out)
        print("message dismissed")
    }

    func impressionDetected(for inAppMessage: InAppMessagingDisplayMessage) {
        // Handle when the in-app message impression is detected
        // This method is called when the message is displayed to the user
        print("impressionDetected.")
    }

    func displayError(for inAppMessage: InAppMessagingDisplayMessage, error: Error) {
        // Handle when there is an error displaying the in-app message
        // You can log the error or perform any necessary actions
        print("displayError.")
    }
}

// URL of images
// nature shaded :-   https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/3579b1c3-1950-408b-ae8c-651c97d01bb9/dfvhmcb-8973ad29-1db9-4bc5-b025-a042e42349c3.jpg/v1/fill/w_525,h_350,q_70,strp/rage_of_clouds_by_xmrfel_dfvhmcb-350t.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9Mjg4MCIsInBhdGgiOiJcL2ZcLzM1NzliMWMzLTE5NTAtNDA4Yi1hZThjLTY1MWM5N2QwMWJiOVwvZGZ2aG1jYi04OTczYWQyOS0xZGI5LTRiYzUtYjAyNS1hMDQyZTQyMzQ5YzMuanBnIiwid2lkdGgiOiI8PTQzMjAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.XnKPrtoklSZUUkDcNxfbxQTI6ECdOckz5talKae3ysM
