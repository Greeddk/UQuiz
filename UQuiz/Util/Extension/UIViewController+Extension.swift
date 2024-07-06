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
    
    func setNavigationBackButton() {
        hideBackButton()
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func hideBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc
    func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String, okTitle: String, action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            action()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showAlertWithCancel(title: String, message: String, okTitle: String, action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            action()
        }
        let cancel = UIAlertAction(title: "ExtensionVC_AlertCancel".localized, style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func showTextFieldAlert(title: String, message: String, placeHolder: String, action: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = placeHolder
        }
        let ok = UIAlertAction(title: "ExtensionVC_AlertOK".localized, style: .default) { _ in
            if let title = alert.textFields?[0].text {
                action(title)
            }
        }
        let cancel = UIAlertAction(title: "ExtensionVC_AlertCancel".localized, style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
