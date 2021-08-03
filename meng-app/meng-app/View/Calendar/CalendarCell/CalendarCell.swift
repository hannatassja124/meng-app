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
    
    override var isSelected: Bool {
            didSet {
                self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.108859323, green: 0.3016951084, blue: 0.3573893309, alpha: 1) : UIColor.clear
                dayOfMonth.textColor = isSelected ? UIColor.white : UIColor.black
            }
          }
}

    

