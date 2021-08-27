//
//  Navigation.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 26/08/21.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setNav(root: UINavigationController) {
        root.navigationBar.isTranslucent = false
        root.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        root.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
}
