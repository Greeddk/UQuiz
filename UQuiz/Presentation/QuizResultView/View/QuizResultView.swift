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
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(460)
        }
        goHomeButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(collectionView.snp.bottom).offset(10)
        }
    }
    
    override func configureView() {
        scoreLabel.font = .pretendard(size: 30, weight: .semiBold)
        goHomeButton.setTitle("홈으로", for: .normal)
        goHomeButton.setTitleColor(.black, for: .normal)
        goHomeButton.tintColor = .green
        collectionView.backgroundColor = .green
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 450)
        return layout
    }
    
    func setUI(score: String) {
        scoreLabel.text = score
    }

}
