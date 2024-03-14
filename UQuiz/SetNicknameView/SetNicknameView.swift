//
//  SetNicknameView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit
import TextFieldEffects

final class SetNicknameView: BaseView {
    
    let roundProfileImage = RoundImageView(frame: .zero)
    let cameraImageView = UIImageView()
    let nicknameTextField = HoshiTextField()
    let validLabel = UILabel()
    let submitButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([roundProfileImage, cameraImageView, nicknameTextField, validLabel, submitButton])
    }
    
    override func setConstraints() {
        roundProfileImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
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
            make.top.equalTo(validLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        roundProfileImage.image = UIImage(systemName: "person")
        roundProfileImage.layer.borderColor = UIColor(red: 73/255, green: 220/255, blue: 146/255, alpha: 1).cgColor
        roundProfileImage.layer.borderWidth = 4
        cameraImageView.image = UIImage(systemName: "camera.circle.fill")
        cameraImageView.backgroundColor = .white
        cameraImageView.layer.cornerRadius = 16
        cameraImageView.tintColor = UIColor(red: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        validLabel.text = "만든 퀴즈에 표시될 닉네임을 입력해주세요"
        nicknameTextField.placeholder = "메이커 닉네임"
        nicknameTextField.placeholderFontScale = 1.1
        nicknameTextField.borderActiveColor = UIColor(red: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        nicknameTextField.borderInactiveColor = .lightGray
        nicknameTextField.placeholderColor = .systemGray
        nicknameTextField.textColor = .lightGray
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.tintColor = .white
        submitButton.backgroundColor = UIColor(red: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        submitButton.setTitle("완료", for: .normal)
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
