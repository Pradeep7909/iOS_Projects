//
//  DataSharingManager.swift
//  NotificationApp
//
//  Created by Qualwebs on 04/01/24.
//

// DataSharingManager.swift in the main app target

import Foundation

var GlobalData = "Null"
class DataSharing {
    static let shared = DataSharing()

    private init() {}

    func showData() {
        print("Heart is selected")
    }
    func showMsg(msg : String){
        print(msg)
        GlobalData = msg
        print(GlobalData)
    }
}


