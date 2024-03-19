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
    
    let indexLabel = UILabel()
    let cardViewContainer = UIView()
    let cardBackgroundView = UIView()
    let posterView = UIImageView()
    let blurView = UIVisualEffectView(effect: createBlurEffect())
    let title = UILabel()
    let numberOfQuizs = UILabel()
    let profileContainer = UIView()
    let makerProfile = UIImageView()
    let makerNickname = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubviews([cardViewContainer, title, numberOfQuizs, profileContainer, indexLabel])
        cardViewContainer.addSubviews([cardBackgroundView])
        cardBackgroundView.addSubviews([posterView])
        posterView.addSubview(blurView)
        profileContainer.addSubviews([makerProfile, makerNickname])
    }
    
    override func prepareForReuse() {
        blurView.alpha = 1.0
    }
    
    override func setConstraints() {
        indexLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(contentView)
        }
        cardViewContainer.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-50)
        }
        cardBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(cardViewContainer)
        }
        posterView.snp.makeConstraints { make in
            make.edges.equalTo(cardBackgroundView)
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(posterView)
        }
        title.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(cardBackgroundView.snp.bottom).offset(20)
        }
        numberOfQuizs.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(2)
            make.trailing.equalTo(posterView.snp.trailing).offset(-4)
        }
        profileContainer.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(30)
            make.centerX.equalTo(contentView)
            make.height.equalTo(60)
        }
        makerProfile.snp.makeConstraints { make in
            make.leading.equalTo(profileContainer).offset(16)
            make.centerY.equalTo(profileContainer)
            make.size.equalTo(30)
        }
        makerNickname.snp.makeConstraints { make in
            make.centerY.equalTo(profileContainer)
            make.leading.equalTo(makerProfile.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(profileContainer.snp.trailing).offset(-16)
        }
    }
    
    override func configureView() {
        indexLabel.font = .systemFont(ofSize: 15)
        cardViewContainer.layer.shadowOffset = .init(width: 0, height: 0.5)
        cardViewContainer.layer.shadowOpacity = 0.7
        cardViewContainer.layer.shadowRadius = 7
        cardViewContainer.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.cornerRadius = 12
        cardBackgroundView.clipsToBounds = true
        title.font = .systemFont(ofSize: 30, weight: .bold)
        title.numberOfLines = 2
        numberOfQuizs.font = .systemFont(ofSize: 14)
        profileContainer.backgroundColor = .test
        profileContainer.layer.cornerRadius = 20
        makerProfile.layer.cornerRadius = 15
        makerProfile.clipsToBounds = true
        makerNickname.font = .systemFont(ofSize: 20)
        blurView.frame = posterView.frame
    }
    
    static func createBlurEffect() -> UIBlurEffect {
        return UIBlurEffect(style: .regular)
    }
    
    func setUI(_ package: RealmPosterQuizPackage, profileImage: UIImage) {
        title.text = package.title
        guard let detailURL = package.quizs.last?.poster else { return }
        let url = PosterURL.thumbnailURL(detailURL: detailURL).endpoint
        posterView.kf.setImage(with: url)
        numberOfQuizs.text = "\(package.numberOfQuiz)문제"
        makerNickname.text = package.makerInfo?.nickname
        makerProfile.image = profileImage
    }
    
    func setIndexLabel(index: String) {
        indexLabel.text = index
    }
    
}

extension QuizCardCollectionViewCell: TransformableView {
    
    func transform(progress: CGFloat) {
        transformCardView(progress: progress)
        transformProfileView(progress: progress)
        
        let normalTransform = CGAffineTransform(translationX: bounds.width * progress, y: 0)
        title.transform = normalTransform
        numberOfQuizs.transform = normalTransform
        indexLabel.transform = normalTransform
    }
    
    
    // MARK: Private functions
    
    private func transformProfileView(progress: CGFloat) {
        let angle = .pi * progress
        var transform = CATransform3DIdentity
        transform.m34 = -0.008
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        profileContainer.layer.transform = transform
        profileContainer.alpha = abs(progress) > 0.5 ? 0 : 1
    }
    
    private func transformCardView(progress: CGFloat) {
        let translationX: CGFloat = bounds.width * progress
        
//        let imageScale = 1 - abs(0.5 * progress)
//        title.transform = CGAffineTransform(translationX: translationX, y: progress * cardViewContainer.frame.height / 8)
//            .scaledBy(x: imageScale, y: imageScale)
        
        let cardBackgroundScale = 1 - abs(0.3 * progress)
        cardBackgroundView.transform = CGAffineTransform(translationX: translationX / 1.55, y: 0)
            .scaledBy(x: cardBackgroundScale, y: cardBackgroundScale)
        
        var transform = CATransform3DIdentity
        if progress < 0 {
            let angle = max(0 - abs(-CGFloat.pi / 3 * progress), -CGFloat.pi / 3)
            transform.m34 = -0.011
            transform = CATransform3DRotate(transform, angle, 0, 1, 1)
        } else {
            let angle = max(0 - abs(-CGFloat.pi / 8 * progress), -CGFloat.pi / 8)
            transform.m34 = 0.002
            transform.m41 = bounds.width * 0.093 * progress
            transform = CATransform3DRotate(transform, angle, 0, 1, -0.1)
        }
        cardViewContainer.layer.transform = transform
    }
    
}


//class QuizCardCollectionViewCell: BaseCollectionViewCell {
//    
//    let cardViewContainer = UIView()
//    let cardBackgroundView = UIView()
//    let posterView = UIImageView()
//    lazy var blurView = UIVisualEffectView(effect: createBlurEffect())
//    let title = UILabel()
//    let numberOfQuiz = UILabel()
//    let makerProfile = UIImageView()
//    let makerNickname = UILabel()
//    
//    override func configureHierarchy() {
//        contentView.addSubviews([cardViewContainer])
//        cardViewContainer.addSubviews([cardBackgroundView])
//        cardBackgroundView.addSubviews([posterView, blurView, title, numberOfQuiz])
//    }
//    
//    override func setConstraints() {
//        cardViewContainer.snp.makeConstraints { make in
//            make.width.equalTo(200)
//            make.height.equalTo(250)
//            make.centerX.equalTo(contentView)
//            make.centerY.equalTo(contentView)
//        }
//        
//        cardBackgroundView.snp.makeConstraints { make in
//            make.width.equalTo(200)
//            make.height.equalTo(250)
//            make.centerX.equalTo(contentView)
//            make.centerY.equalTo(contentView)
//        }
//        
//        posterView.snp.makeConstraints { make in
//            make.edges.equalTo(cardBackgroundView)
//        }
//        
//        blurView.snp.makeConstraints { make in
//            make.edges.equalTo(cardBackgroundView)
//        }
//        
//        title.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(cardBackgroundView.snp.top).offset(10)
//            make.horizontalEdges.equalToSuperview().inset(4)
//        }
//        
//        numberOfQuiz.snp.makeConstraints { make in
//            make.top.equalTo(cardBackgroundView.snp.top).offset(10)
//            make.trailing.equalTo(cardBackgroundView.snp.trailing).offset(-10)
//        }
//    }
//    
//    override func configureView() {
//        cardViewContainer.layer.shadowOffset = .init(width: 0, height: 0.5)
//        cardViewContainer.layer.shadowOpacity = 0.7
//        cardViewContainer.layer.shadowRadius = 7
//        cardViewContainer.layer.shadowColor = UIColor.black.cgColor
//        cardBackgroundView.layer.cornerRadius = 12
//        cardBackgroundView.clipsToBounds = true
//        let url = PosterURL.thumbnailURL(detailURL: "/7rUFYRfYV6c4yXiKBvKWOCRjimc.jpg").endpoint
//        posterView.kf.setImage(with: url)
//        title.text = "이거슨... 퀴즈 이름"
//        title.font = .systemFont(ofSize: 27, weight: .bold)
//        title.numberOfLines = 2
//        numberOfQuiz.text = "20"
//    }
//    
//    private func createBlurEffect() -> UIBlurEffect {
//        return UIBlurEffect(style: .regular)
//    }
//}

//extension QuizCardCollectionViewCell: ScaleTransformView {
//    
//    var scaleOptions: ScaleTransformViewOptions {
//        .layout(.invertedCylinder)
//    }
//    
//}
