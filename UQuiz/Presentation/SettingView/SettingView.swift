//
//  SettingView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    
    let logoView = UIImageView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let profileContainer = UIView()
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let changeNicknameButton = UIButton()
    let staticsView = UIView()
    
    override func configureHierarchy() {
        self.addSubviews([logoView, scrollView])
        scrollView.addSubviews([contentView])
        contentView.addSubviews([profileContainer, staticsView])
        profileContainer.addSubviews([profileImage, nicknameLabel, changeNicknameButton])
    }
    
    override func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-40)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        profileContainer.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.height.equalTo(100)
        }
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(profileContainer.snp.leading).offset(20)
            make.centerY.equalTo(profileContainer)
            make.size.equalTo(60)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.centerY.equalTo(profileImage)
        }
        changeNicknameButton.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(nicknameLabel).offset(1)
        }
        staticsView.snp.makeConstraints { make in
            make.top.equalTo(profileContainer.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }

    override func configureView() {
        logoView.image = .uquizLogo
        logoView.contentMode = .scaleAspectFit
        profileContainer.layer.cornerRadius = 12
        profileContainer.backgroundColor = .pointOrange
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 4
        profileImage.layer.cornerRadius = 30
        profileImage.image = UIImage(systemName: "star")
        nicknameLabel.font = .pretendard(size: 30, weight: .medium)
        nicknameLabel.textColor = .white
        nicknameLabel.text = "test"
        changeNicknameButton.tintColor = .white
        changeNicknameButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
    }
}
