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
            outputNicknameValidation.value = "닉네임을 두글자 이상 입력해주세요"
            outputValidation.value = false
        } else if text.count > 10 {
            outputNicknameValidation.value = "닉네임은 10글자 이하로 입력해주세요"
            outputValidation.value = false
        } else if text.contains(" ") {
            outputNicknameValidation.value = "공백은 포함할 수 없습니다"
            outputValidation.value = false
        } else {
            outputNicknameValidation.value = "사용해도 좋은 닉네임입니다!"
            outputValidation.value = true
        }
    }
    
    private func changeUserState() {
        udManager.userState = true
    }
    
}
