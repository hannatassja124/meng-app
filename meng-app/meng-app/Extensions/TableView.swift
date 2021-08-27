//
//  TableView.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 26/08/21.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.108859323, green: 0.3016951084, blue: 0.3573893309, alpha: 0.4)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
        
        var bgImage: UIImageView?
        let image: UIImage = UIImage(named: "Meng-3")!
        bgImage = UIImageView(image: image)
        bgImage!.frame = CGRect(x: 95, y: 12, width: 160, height: 100)
        
        self.backgroundView?.addSubview(bgImage!)
        
        let constraints = [
            bgImage!.centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            bgImage!.centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

