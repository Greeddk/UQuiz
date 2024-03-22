//
//  SettingViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let profileViewModel = ProfileManagerViewModel()
    private let mainView = SettingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewModel.inputLoadProfileImageTrigger.value = ()
    }
    // TODO: 이미지나 닉네임이 변경되었을 시, 샐이 리로드 되게하기
    
    override func configureViewController() {
        mainView.changeNicknameButton.addTarget(self, action: #selector(changeNicknameButtonClicked), for: .touchUpInside)
    }
   
    @objc
    private func changeNicknameButtonClicked() {
        let vc = SetProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
