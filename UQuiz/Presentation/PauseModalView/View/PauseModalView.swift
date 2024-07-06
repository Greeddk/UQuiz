//
//  PauseModalView.swift
//  UQuiz
//
//  Created by Greed on 3/26/24.
//

import UIKit
import SnapKit

final class PauseModalView: BaseView {
    
    private let backView = UIButton()
    let resumeButton = UIButton()
    let exitButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        addSubviews([backView, resumeButton, exitButton])
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        resumeButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(30)
            make.leading.equalTo(backView.snp.leading).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(resumeButton.snp.bottom).offset(20)
            make.leading.equalTo(resumeButton)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 30
        resumeButton.setTitle("PauseModal_Continue".localized, for: .normal)
        resumeButton.setTitleColor(.white, for: .normal)
        resumeButton.titleLabel?.font = .pretendard(size: 24, weight: .bold)
        resumeButton.backgroundColor = .pointOrange
        resumeButton.layer.cornerRadius = 12
        exitButton.setTitle("PauseModal_Exit".localized, for: .normal)
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.titleLabel?.font = .pretendard(size: 24, weight: .bold)
        exitButton.backgroundColor = .pointOrange
        exitButton.layer.cornerRadius = 12
    }
    
}
