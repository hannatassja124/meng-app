//
//  Core.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 16/08/21.
//

import Foundation

class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
