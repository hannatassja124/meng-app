//
//  ActivityLogDatePickerHeader.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 29/07/21.
//

import UIKit

protocol ActivityLogDatePickerHeaderProtocol {
    func DidToggleSwitch(SwitchStatus: Int)
}



class ActivityLogDatePickerHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var LabelReminder: UILabel!
    @IBOutlet weak var SwitchReminder: UISwitch!
    var SwitchStatus = 0
    var Delegate: ActivityLogDatePickerHeaderProtocol?
    
    @IBAction func SwitchPressed(_ sender: UISwitch) {
        if SwitchReminder.isOn {
            SwitchStatus = 1
        }
        else{
            SwitchStatus = 0
        }
        Delegate?.DidToggleSwitch(SwitchStatus: SwitchStatus)
        print("Delegate Origin")
        print(SwitchStatus)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
