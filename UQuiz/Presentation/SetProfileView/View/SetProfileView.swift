//
//  SetProfileView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit
import TextFieldEffects

final class SetProfileView: BaseView {
    
    let logoView = UIImageView()
    let roundProfileImage = RoundImageView(frame: .zero)
    let cameraImageView = UIImageView()
    let nicknameTextField = HoshiTextField()
    let validLabel = UILabel()
    let submitButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([logoView, roundProfileImage, cameraImageView, nicknameTextField, validLabel, submitButton])
    }
    
    override func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
        roundProfileImage.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(30)
            make.size.equalTo(100)
            make.centerX.equalTo(self)
        }
        cameraImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.bottom.equalTo(roundProfileImage.snp.bottom).offset(1)
            make.trailing.equalTo(roundProfileImage.snp.trailing).offset(1)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(cameraImageView.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        validLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        logoView.image = .uquizLogo
        logoView.contentMode = .scaleAspectFit
        roundProfileImage.image = .defaultAvatar
        roundProfileImage.layer.borderColor = UIColor.pointOrange.cgColor
        roundProfileImage.layer.borderWidth = 4
        roundProfileImage.contentMode = .scaleAspectFill
        cameraImageView.image = UIImage(systemName: "camera.circle.fill")
        cameraImageView.backgroundColor = .white
        cameraImageView.layer.cornerRadius = 16
        cameraImageView.tintColor = .pointOrange
        validLabel.text = "만든 퀴즈에 표시될 닉네임을 입력해주세요"
        validLabel.font = .pretendard(size: 16, weight: .regular)
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.font = .pretendard(size: 16, weight: .regular)
        nicknameTextField.placeholderFontScale = 1.1
        nicknameTextField.borderActiveColor = .pointOrange
        nicknameTextField.textColor = .black
        nicknameTextField.borderInactiveColor = .lightGray
        nicknameTextField.placeholderColor = .systemGray
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.backgroundColor = .pointOrange
        submitButton.setTitle("완료", for: .normal)
        submitButton.titleLabel?.font = .pretendard(size: 20, weight: .bold)
    }
    
    func changeLabelColor(isValidate: Bool) {
        if isValidate {
            validLabel.textColor = .green
        } else {
            validLabel.textColor = .systemRed
        }
    }
    
    func shakeTextfield() {
        nicknameTextField.shake()
    }
    
}
