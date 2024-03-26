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
    private let levelImageView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let goHomeButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([scoreLabel, collectionView, goHomeButton])
    }
    
    override func setConstraints() {
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(300)
        }
        collectionView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(500)
        }
        goHomeButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        collectionView.showsHorizontalScrollIndicator = false
        scoreLabel.font = .pretendard(size: 30, weight: .bold)
        scoreLabel.textAlignment = .center
        goHomeButton.setTitle("홈으로", for: .normal)
        goHomeButton.setTitleColor(.white, for: .normal)
        goHomeButton.titleLabel?.font = .pretendard(size: 24, weight: .bold)
        goHomeButton.backgroundColor = .pointOrange
        goHomeButton.layer.cornerRadius = 12
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 320, height: 500)
        return layout
    }
    
    func setUI(score: String) {
        scoreLabel.text = score
    }

}
