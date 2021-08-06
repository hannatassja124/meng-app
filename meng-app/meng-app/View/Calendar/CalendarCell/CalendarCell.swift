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
                self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1) : UIColor.clear
                dayOfMonth.textColor = isSelected ? UIColor.white : UIColor.black
            }
          }
}

    

