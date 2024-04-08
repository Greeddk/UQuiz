//
//  CreateMatchViewController.swift
//  UQuiz
//
//  Created by Greed on 4/8/24.
//

import UIKit

final class CreateMatchViewController: BaseViewController {
    
    let mainView = CreateMatchView()
    let matchManager = GameManager.shared
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureViewController() {
        mainView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        matchManager.generateRandomPlayCode()
        mainView.shareNumberTextField.text = matchManager.groupNumber
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
}
