//
//  GroupedActivities.swift
//  meng-app
//
//  Created by Arya Ilham on 24/08/21.
//

import Foundation

struct GroupedActivities {
    var sectionTitle:String
    var activities = [Activity]()
    
    init(sectionTitle:String) {
        self.sectionTitle = sectionTitle
    }
}
