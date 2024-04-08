//
//  RecieveMatchViewController.swift
//  UQuiz
//
//  Created by Greed on 4/8/24.
//

import UIKit

final class ReceiveMatchViewController: BaseViewController {
    
    let mainView = ReceiveMatchView()
    let inputNumber = "    "
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureViewController() {

    }

}
