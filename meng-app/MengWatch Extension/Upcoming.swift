//
//  Upcoming.swift
//  MengWatch Extension
//
//  Created by Hannatassja Hardjadinata on 27/08/21.
//

import Foundation

struct Upcoming: Hashable, Codable {
    var date: Date
    var time: Date
    var tagColor : Int
    var name : String
    var detail : String
}
