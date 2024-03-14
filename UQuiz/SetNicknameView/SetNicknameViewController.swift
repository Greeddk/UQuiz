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
    let imageViewModel = ImageManagerViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputNicknameValidation.noInitBind { [weak self] text in
            self?.mainView.validLabel.text = text
        }
        viewModel.outputValidation.noInitBind { [weak self] validate in
            self?.mainView.changeLabelColor(isValidate: validate)
        }
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
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc
    private func submitButtonClicked() {
        if !viewModel.udManager.userState {
            if viewModel.outputValidation.value {
                viewModel.inputUserStateChangeTrigger.value = ()
                imageViewModel.inputUserProfileSaveTrigger.value = ()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = MainTabBarController()
                sceneDelegate?.window?.makeKeyAndVisible()
            } else {
                mainView.shakeTextfield()
            }
        } else {
            navigationController?.dismiss(animated: true)
        }
    }

}

extension SetNicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputTextFieldChanged.value = textField.text
    }
}

extension SetNicknameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainView.roundProfileImage.image = pickedImage
            imageViewModel.inputUserProfileImage.value = pickedImage
        }
        dismiss(animated: true)
    }
}
