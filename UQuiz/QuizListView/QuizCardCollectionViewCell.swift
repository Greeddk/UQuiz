//
//  QuizCardCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout
import Kingfisher

class QuizCardCollectionViewCell: BaseCollectionViewCell {
    
    let cardViewContainer = UIView()
    let cardBackgroundView = UIView()
    let posterView = UIImageView()
    lazy var blurView = UIVisualEffectView(effect: createBlurEffect())
    let title = UILabel()
    let numberOfQuiz = UILabel()
    let makerProfile = UIImageView()
    let makerNickname = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubviews([cardViewContainer])
        cardViewContainer.addSubviews([cardBackgroundView])
        cardBackgroundView.addSubviews([posterView, blurView, title, numberOfQuiz])
    }
    
    override func setConstraints() {
        cardViewContainer.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        cardBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        posterView.snp.makeConstraints { make in
            make.edges.equalTo(cardBackgroundView)
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(cardBackgroundView)
        }
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardBackgroundView.snp.top).offset(10)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        
        numberOfQuiz.snp.makeConstraints { make in
            make.top.equalTo(cardBackgroundView.snp.top).offset(10)
            make.trailing.equalTo(cardBackgroundView.snp.trailing).offset(-10)
        }
    }
    
    //TODO: corner radius 적용
    override func configureView() {
        cardViewContainer.layer.shadowOffset = .init(width: 0, height: 0.5)
        cardViewContainer.layer.shadowOpacity = 0.7
        cardViewContainer.layer.shadowRadius = 7
        cardViewContainer.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.cornerRadius = 12
        cardBackgroundView.clipsToBounds = true
        let url = PosterURL.thumbnailURL(detailURL: "/7rUFYRfYV6c4yXiKBvKWOCRjimc.jpg").endpoint
        posterView.kf.setImage(with: url)
        title.text = "이거슨... 퀴즈 이름"
        title.font = .systemFont(ofSize: 27, weight: .bold)
        title.numberOfLines = 2
        numberOfQuiz.text = "20"
    }
    
    private func createBlurEffect() -> UIBlurEffect {
        return UIBlurEffect(style: .regular)
    }
}

extension QuizCardCollectionViewCell: ScaleTransformView {
    
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.invertedCylinder)
    }
    
}
