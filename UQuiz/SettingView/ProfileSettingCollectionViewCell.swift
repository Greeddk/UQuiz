//
//  ProfileSettingCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit

final class ProfileSettingCollectionViewCell: BaseCollectionViewCell {
    
    let roundProfileImage = RoundImageView(frame: .zero)
    let nicknameLabel = UILabel()
    let changeNicknameButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubviews([roundProfileImage, nicknameLabel, changeNicknameButton])
    }
    
    override func setConstraints() {
        roundProfileImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(roundProfileImage.snp.trailing).offset(20)
            make.centerY.equalTo(roundProfileImage)
        }
        
        changeNicknameButton.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(nicknameLabel)
        }
    }
    
    override func configureView() {
        roundProfileImage.layer.borderColor = UIColor.green.cgColor
        roundProfileImage.layer.borderWidth = 4
        changeNicknameButton.tintColor = .white
    }
    
}
