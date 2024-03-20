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

final class QuizCardCollectionViewCell: BaseCollectionViewCell {
    
    let indexLabel = UILabel()
    let cardViewContainer = UIView()
    let cardBackgroundView = UIView()
    let posterView = UIImageView()
    let title = UILabel()
    let numberOfQuizs = UILabel()
    let profileContainer = UIView()
    let makerProfile = UIImageView()
    let makerNickname = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubviews([cardViewContainer, title, numberOfQuizs, profileContainer, indexLabel])
        cardViewContainer.addSubviews([cardBackgroundView])
        cardBackgroundView.addSubviews([posterView])
        profileContainer.addSubviews([makerProfile, makerNickname])
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
        title.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(cardBackgroundView.snp.bottom).offset(40)
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
        indexLabel.font = .pretendard(size: 15, weight: .regular)
        cardViewContainer.layer.shadowOffset = .init(width: 0, height: 0.5)
        cardViewContainer.layer.shadowOpacity = 0.7
        cardViewContainer.layer.shadowRadius = 7
        cardViewContainer.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.cornerRadius = 12
        cardBackgroundView.clipsToBounds = true
        title.font = .pretendard(size: 30, weight: .bold)
        title.numberOfLines = 2
        numberOfQuizs.font = .pretendard(size: 14, weight: .thin)
        profileContainer.backgroundColor = .test
        profileContainer.layer.cornerRadius = 20
        makerProfile.layer.cornerRadius = 15
        makerProfile.clipsToBounds = true
        makerNickname.font = .pretendard(size: 20, weight: .regular)
    }
    
    func setUI(_ package: RealmPosterQuizPackage, profileImage: UIImage) {
        title.text = package.title
        guard let detailURL = package.quizs.last?.poster else { return }
        let url = PosterURL.thumbnailURL(detailURL: detailURL).endpoint
        let processor = BlurImageProcessor(blurRadius: 20.0)
        posterView.kf.setImage(with: url, options: [.processor(processor)])
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
