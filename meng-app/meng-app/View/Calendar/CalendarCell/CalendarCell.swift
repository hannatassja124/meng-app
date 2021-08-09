//
//  CalendarCell.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 29/07/21.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dayOfMonth: UILabel!
    
    var dateIsHaveEvent: Bool? {
        didSet {
            cellConfig()
        }
    }

    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1) : UIColor.clear
            dayOfMonth.textColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
    func cellConfig() {
        guard let object = dateIsHaveEvent else { return }
        self.contentView.backgroundColor = object ? #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1) : UIColor.clear
        dayOfMonth.textColor = object ? UIColor.white : UIColor.black
    }
    
//    var isSetDate: Bool {
//        didSet {
//            dayOfMonth.textColor = isSetDate ? #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1) : #colorLiteral(red: 0.1047133282, green: 0.2670978308, blue: 0.3146489859, alpha: 1)
//        }
//    }
}

    

