//
//  QuizResultView.swift
//  UQuiz
//
//  Created by Greed on 3/17/24.
//

import UIKit
import SnapKit

final class QuizResultView: BaseView {

    private let scoreLabel = UILabel()
    let goHomeButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([scoreLabel, goHomeButton])
    }
    
    override func setConstraints() {
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        goHomeButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(scoreLabel.snp.bottom).offset(50)
        }
    }
    
    override func configureView() {
        scoreLabel.font = .pretendard(size: 30, weight: .semiBold)
        goHomeButton.setTitle("홈으로", for: .normal)
        goHomeButton.setTitleColor(.black, for: .normal)
        goHomeButton.tintColor = .green
    }
    
    func setUI(score: String) {
        scoreLabel.text = score
    }

}
