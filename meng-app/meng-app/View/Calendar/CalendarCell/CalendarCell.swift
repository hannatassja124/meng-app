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
    @IBOutlet weak var markImage: UIImageView!
    
    var dateIsHaveEvent: Bool? {
        didSet {
            cellConfig()
        }
    }

    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.9960932136, green: 0.5338024497, blue: 0.51013726, alpha: 1) : UIColor.clear
            dayOfMonth.textColor = isSelected ? UIColor.white : #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        }
    }
    
    func cellConfig() {
        guard let object = dateIsHaveEvent else { return }
        self.contentView.backgroundColor = object ? #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1) : UIColor.clear
        dayOfMonth.textColor = object ? UIColor.white : UIColor.black
    }
    
    func setMark(){
        
    }
    
//    var isSetDate: Bool {
//        didSet {
//            dayOfMonth.textColor = isSetDate ? #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1) : #colorLiteral(red: 0.1047133282, green: 0.2670978308, blue: 0.3146489859, alpha: 1)
//        }
//    }
}

    

