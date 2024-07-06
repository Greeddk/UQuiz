//
//  SetProfileViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import Foundation

final class SetProfileViewModel {
    
    let repository = PosterQuizPackageRepository()
    private let udManager = UserDefaultsManager.shared
    
    var inputUserStateChangeTrigger: Observable<Void?> = Observable(nil)
    var inputTextFieldChanged: Observable<String?> = Observable(nil)
    var inputInitialDataTrigger: Observable<Void?> = Observable(nil)
    
    var outputNicknameValidation: Observable<String> = Observable("")
    var outputValidation: Observable<Bool> = Observable(false)
    
    
    init() {
        inputInitialDataTrigger.noInitBind { _ in
            self.fetchInitialData()
        }
        inputUserStateChangeTrigger.noInitBind { [weak self] _ in
            self?.changeUserState()
        }
        inputTextFieldChanged.noInitBind { [weak self] text in
            guard let text = text else { return }
            self?.validateNickname(text)
        }
    }
    
    private func  fetchInitialData() {
        repository.copyInitialRealm()
        repository.fetchInitialData()
    }
    
    private func validateNickname(_ text: String) {
        if text.count <= 1 {
            outputNicknameValidation.value = "SetProfileVM_ShortNickMessage".localized
            outputValidation.value = false
        } else if text.count > 10 {
            outputNicknameValidation.value = "SetProfileVM_LongNickMessage".localized
            outputValidation.value = false
        } else if text.contains(" ") {
            outputNicknameValidation.value = "SetProfileVM_IncludeSpaceNickMessage".localized
            outputValidation.value = false
        } else {
            outputNicknameValidation.value = "SetProfileVM_ValidateNickMessage".localized
            outputValidation.value = true
        }
    }
    
    private func changeUserState() {
        udManager.userState = true
    }
    
}
