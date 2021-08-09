//
//  TypeHelper.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 07/08/21.
//

import UIKit

class TypeHelper {
    static func checkType(typeNumber: String) -> String{
        var selectedType: String?
        
        switch typeNumber {
        case "1":
            selectedType = "Vaccine"
        case "2":
            selectedType = "Appointment"
        case "3":
            selectedType = "Treatment"
        case "4":
            selectedType = "Symptoms"
        case "5":
            selectedType = "Others"
        default:
            selectedType = "Others"
        }
        
        return selectedType!
    }
}
