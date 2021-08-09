//
//  ReminderHelper.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 07/08/21.
//

import UIKit

class ReminderHelper {
    static func checkReminder(typeNumber: Int64) -> String{
        var selectedType: String?
        
        switch typeNumber {
        case 5, 10, 15, 30:
            selectedType = "\(typeNumber) minutes before"
        case 60, 120:
            selectedType = "\(typeNumber/60) hours before"
        case 1440, 2880:
            selectedType = "\(typeNumber/1440) days before"
        case 10080:
            selectedType = "\(typeNumber/10080) week before"
        default:
            selectedType = "None"
        }
        
        return selectedType!
    }
}
