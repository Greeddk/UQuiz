//
//  SolvePosterAreaQuizView.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SolvePosterAreaQuizView: BaseView {
    
    let posterView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let answerTextField = UITextField()
    let submitButton = UIButton()
    private var screenWidth: CGFloat = 0
    
    //MARK: layout
    override func layoutSubviews() {
        screenWidth = self.frame.width
        var collectionViewWidth: CGFloat = 0
        if screenWidth >= 410 {
            collectionViewWidth = 400
        } else {
            collectionViewWidth = 350
        }
        posterView.snp.updateConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-30)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(collectionViewWidth)
            make.height.equalTo(collectionViewWidth * 1.5)
        }
        collectionView.snp.updateConstraints { make in
            make.edges.equalTo(posterView)
        }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionViewWidth / 50, height: collectionViewWidth / 50)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func configureHierarchy() {
        addSubviews([posterView, collectionView, answerTextField, submitButton])
    }
    
    override func setConstraints() {
        posterView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-30)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(360)
            make.height.equalTo(540)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(posterView)
        }
        
        answerTextField.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-70)
            make.height.equalTo(40)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(answerTextField)
            make.leading.equalTo(answerTextField.snp.trailing)
            make.size.equalTo(40)
        }
        
    }
    
    override func configureView() {
        collectionView.backgroundColor = .clear
        submitButton.setTitle("test", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        answerTextField.placeholder = "정답 입력"
        answerTextField.layer.cornerRadius = 12
        answerTextField.layer.borderWidth = 1
        answerTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func fetchPoster(detailURL: String?) {
        guard let detailUrl = detailURL else { return }
        let url = PosterURL.imageURL(detailURL: detailUrl).endpoint
        posterView.kf.setImage(with: url)
        posterView.contentMode = .scaleToFill
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }
    
}
