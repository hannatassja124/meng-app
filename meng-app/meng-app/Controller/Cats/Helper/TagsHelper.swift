//
//  TagsHelper.swift
//  meng-app
//
//  Created by Arya Ilham on 29/07/21.
//

import UIKit

class TagsHelper {
    static func checkColor(tagsNumber: Int16) -> UIColor{
        var selectedColor: UIColor?
        
        switch tagsNumber {
        case 1:
            selectedColor = .green
        case 2:
            selectedColor = .yellow
        case 3:
            selectedColor = .orange
        case 4:
            selectedColor = .red
        case 5:
            selectedColor = .blue
        case 6:
            selectedColor = .systemTeal
        case 7:
            selectedColor = .systemIndigo
        case 8:
            selectedColor = .purple
        case 9:
            selectedColor = .systemPink
        case 10:
            selectedColor = .white
        case 11:
            selectedColor = .brown
        case 12:
            selectedColor = .black
        default:
            selectedColor = .black
        }
        
        return selectedColor!
    }
}
