//
//  SetProfileView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit

final class SetProfileView: BaseView {
    
    let logoView = UIImageView()
    let roundProfileImage = RoundImageView(frame: .zero)
    let cameraImageView = UIImageView()
    let textFieldBackground = UIView()
    let nicknameTextField = UITextField()
    let validLabel = UILabel()
    let submitButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([logoView, roundProfileImage, cameraImageView, textFieldBackground, nicknameTextField, validLabel, submitButton])
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
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.top.equalTo(cameraImageView.snp.bottom).offset(50)
            make.height.equalTo(40)
        }
        textFieldBackground.snp.makeConstraints { make in
            make.verticalEdges.equalTo(nicknameTextField).inset(-5)
            make.horizontalEdges.equalTo(nicknameTextField).inset(-20)
        }
        validLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(20)
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
        validLabel.text = "SetProfileView_ValidLabel".localized
        validLabel.numberOfLines = 2
        validLabel.font = .pretendard(size: 16, weight: .regular)
        textFieldBackground.layer.borderColor = UIColor.pointOrange.cgColor
        textFieldBackground.layer.borderWidth = 2
        textFieldBackground.layer.cornerRadius = 12
        nicknameTextField.placeholder = "SetProfileView_Nickname".localized
        nicknameTextField.textColor = .black
        nicknameTextField.font = .pretendard(size: 16, weight: .regular)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.backgroundColor = .pointOrange
        submitButton.setTitle("Done".localized, for: .normal)
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
