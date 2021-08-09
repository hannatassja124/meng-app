//
//  ActivitiesTypeStruct.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 08/08/21.
//

import Foundation

struct ActivitiesTypeStruct {
    var name = ""
    var iconName = ""
    var isSelected = false
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
    }
}
