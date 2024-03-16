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
        case nickname
        case profileImage
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
    
    var nickname: String {
        get {
            ud.string(forKey: UDKey.nickname.rawValue) ?? ""
        }
        set {
            ud.setValue(newValue, forKey: UDKey.nickname.rawValue)
        }
    }
    
    var profileImage: String {
        get {
            ud.string(forKey: UDKey.profileImage.rawValue) ?? ""
        }
        set {
            ud.setValue(newValue, forKey: UDKey.profileImage.rawValue)
        }
    }
    
}
