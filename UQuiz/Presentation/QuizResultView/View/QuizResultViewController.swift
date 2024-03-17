//
//  QuizResultViewController.swift
//  UQuiz
//
//  Created by Greed on 3/17/24.
//

import UIKit

final class QuizResultViewController: BaseViewController {
    
    private let mainView = QuizResultView()
    let viewModel = QuizResultViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureViewController() {
        mainView.setUI(score: viewModel.outputCorretRate.value)
        hideBackButton()
        mainView.goHomeButton.addTarget(self, action: #selector(goHomeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func goHomeButtonClicked() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
