//
//  SetNicknameViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class SetNicknameViewController: BaseViewController {
    
    let mainView = SetNicknameView()
    let viewModel = SetNicknameViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureViewController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped))
        mainView.roundProfileImage.addGestureRecognizer(tapGesture)
        mainView.roundProfileImage.isUserInteractionEnabled = true
        mainView.submitButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
        mainView.nicknameTextField.delegate = self
    }
    
    @objc
    private func tapGestureTapped() {
        print(#function)
    }
    
    @objc
    private func submitButtonClicked() {
        viewModel.inputUserStateChangeTrigger.value = ()
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = MainTabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}

extension SetNicknameViewController: UITextFieldDelegate {
    
}
