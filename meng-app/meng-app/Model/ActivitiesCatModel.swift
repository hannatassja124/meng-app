//
//  ActivitiesCatModel.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 08/08/21.
//

import Foundation

struct CatData {
    var cat = Cats()
    var isSelected = false
    
    init(cat: Cats) {
        self.cat = cat
    }
}
