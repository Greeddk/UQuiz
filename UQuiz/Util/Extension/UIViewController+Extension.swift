//
//  UIViewcontroller+Extension.swift
//  UQuiz
//
//  Created by Greed on 3/10/24.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenViewIsTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func showAlert(title: String, message: String, okTitle: String, action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            action()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showTextFieldAlert(title: String, message: String, placeHolder: String, action: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = placeHolder
        }
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            if let title = alert.textFields?[0].text {
                action(title)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

// MARK: Keyboard 올라올때 뷰도 같이 올라가게 설정
extension UIViewController {
    func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height

        // ⭐️ 이 조건을 넣어주지 않으면, 각각의 텍스트필드마다 keyboardWillShow 동작이 실행되므로 아래와 같은 현상이 발생
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
}
