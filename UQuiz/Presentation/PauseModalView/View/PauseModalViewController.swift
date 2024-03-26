//
//  PauseModalViewController.swift
//  UQuiz
//
//  Created by Greed on 3/26/24.
//

import UIKit

final class PauseModalViewController: BaseViewController {

    let mainView = PauseModalView()
    
    var resumeCompletionHandler: (() -> Void)?
    var exitCompletionHandler: (() -> Void)?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    override func configureViewController() {
        mainView.resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        mainView.exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }

}

extension PauseModalViewController {
    
    @objc private func resumeButtonTapped() {
        resumeCompletionHandler?()
        dismiss(animated: true)
    }
    
    @objc private func exitButtonTapped() {
        exitCompletionHandler?()
        dismiss(animated: true)
    }
}
