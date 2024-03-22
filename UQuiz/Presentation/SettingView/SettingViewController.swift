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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileViewModel.inputLoadProfileImageTrigger.value = ()
        profileViewModel.outputUserProfileImage.bind { image in
            self.mainView.fetchProfile(image: image)
        }
        profileViewModel.outputNickname.bind { nickname in
            self.mainView.nicknameLabel.text = nickname
        }
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
