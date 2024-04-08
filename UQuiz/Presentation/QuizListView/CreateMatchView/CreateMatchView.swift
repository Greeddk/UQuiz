//
//  CreateMatchView.swift
//  UQuiz
//
//  Created by Greed on 4/8/24.
//

import UIKit
import SnapKit

final class CreateMatchView: BaseView {
    
    let matchLabel = UILabel()
    let dismissButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        let image = UIImage(systemName: "x.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        return button
    }()
    let shareNumberTextField = UITextField()
    let copyNumberButton = UIButton()
    let infoLabel = UILabel()
    
    override func configureHierarchy() {
        self.addSubviews([matchLabel, dismissButton, shareNumberTextField, copyNumberButton, infoLabel])
    }
    
    override func setConstraints() {
        matchLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        dismissButton.snp.makeConstraints { make in
            make.centerY.equalTo(matchLabel)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
        shareNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(matchLabel.snp.bottom).offset(180)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        copyNumberButton.snp.makeConstraints { make in
            make.centerY.equalTo(shareNumberTextField)
            make.trailing.equalTo(shareNumberTextField.snp.trailing).offset(-10)
            make.size.equalTo(32)
        }
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(shareNumberTextField.snp.bottom).offset(12)
        }
    }
    
    override func configureView() {
        matchLabel.font = .pretendard(size: 40, weight: .bold)
        matchLabel.textColor = .black
        matchLabel.text = "퀴즈 보내기"
        shareNumberTextField.backgroundColor = .systemGray5
        shareNumberTextField.layer.cornerRadius = 20
        shareNumberTextField.font = .pretendard(size: 32, weight: .semiBold)
        shareNumberTextField.textColor = .pointOrange
        shareNumberTextField.textAlignment = .center
        shareNumberTextField.text = "4567"
        shareNumberTextField.isEnabled = false
        copyNumberButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
        copyNumberButton.tintColor = .pointOrange
        infoLabel.text = "퀴즈를 공유할 친구에게 코드를 알려주세요"
        infoLabel.textColor = .gray
        infoLabel.font = .pretendard(size: 14, weight: .regular)
    }

}
