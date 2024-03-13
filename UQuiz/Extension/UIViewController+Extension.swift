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
    
    func showAlert(title: String, message: String, okTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
