//
//  SetNicknameViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import Foundation

final class SetNicknameViewModel {
    
    let udManager = UserDefaultsManager.shared
    
    var inputUserStateChangeTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputUserStateChangeTrigger.noInitBind { _ in
            self.changeUserState()
        }
    }
    
    private func validateNickname() {
        
    }
    
    private func changeUserState() {
        udManager.userState = true
    }
    
    
}
