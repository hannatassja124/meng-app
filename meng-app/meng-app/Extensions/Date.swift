//
//  Date.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 26/08/21.
//

import Foundation
import UIKit

extension Date {
    var month: Int {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.component(.month, from: self as Date)
    }
    var year: Int {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.component(.year, from: self as Date)
    }
}

