//
//  UserDefaultsManager.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    enum UDKey: String {
        case userState
    }
    
    let ud = UserDefaults.standard
    
    var userState: Bool {
        get {
            ud.bool(forKey: UDKey.userState.rawValue)
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userState.rawValue)
        }
    }
}
