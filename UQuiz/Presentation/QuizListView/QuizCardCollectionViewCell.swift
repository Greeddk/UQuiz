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
    
    let profileContainer = UIView()
    let makerProfile = UIImageView()
    let makerNickname = UILabel()
    let cardViewContainer = UIView()
    let cardBackgroundView = UIView()
    let levelImage = UIImageView()
    let posterView = UIImageView()
    let title = UILabel()
    let numberOfQuizs = UILabel()
    let playButton = UIButton()
    let indexLabel = UILabel()
    let deleteButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubviews([cardViewContainer, title, numberOfQuizs, profileContainer, indexLabel, deleteButton, playButton])
        cardViewContainer.addSubviews([cardBackgroundView])
        cardBackgroundView.addSubviews([posterView])
        cardViewContainer.addSubview(levelImage)
        profileContainer.addSubviews([makerProfile, makerNickname])
    }
    
    override func setConstraints() {
        cardViewContainer.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-75)
        }
        cardBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(cardViewContainer)
        }
        profileContainer.snp.makeConstraints { make in
            make.bottom.equalTo(cardViewContainer.snp.top).offset(-20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(50)
        }
        makerProfile.snp.makeConstraints { make in
            make.leading.equalTo(profileContainer).offset(16)
            make.centerY.equalTo(profileContainer)
            make.size.equalTo(40)
        }
        makerNickname.snp.makeConstraints { make in
            make.centerY.equalTo(profileContainer)
            make.leading.equalTo(makerProfile.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(profileContainer.snp.trailing).offset(-16)
        }
        levelImage.snp.makeConstraints { make in
            make.centerX.equalTo(cardBackgroundView)
            make.centerY.equalTo(cardBackgroundView).offset(-40)
            make.height.equalTo(90)
        }
        posterView.snp.makeConstraints { make in
            make.edges.equalTo(cardBackgroundView)
        }
        title.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(cardBackgroundView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
        numberOfQuizs.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(2)
            make.trailing.equalTo(posterView.snp.trailing).offset(-4)
        }
        playButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
        }
        indexLabel.snp.makeConstraints { make in
            make.top.equalTo(deleteButton)
            make.centerX.equalTo(contentView)
        }
    }
    
    // MARK: View
    override func configureView() {
        profileContainer.backgroundColor = .pointOrange
        profileContainer.layer.cornerRadius = 20
        makerProfile.contentMode = .scaleAspectFill
        makerProfile.clipsToBounds = true
        makerProfile.layer.cornerRadius = 20
        makerNickname.font = .pretendard(size: 20, weight: .regular)
        makerNickname.textColor = .white
        levelImage.contentMode = .scaleAspectFit
        cardViewContainer.layer.shadowOffset = .init(width: 0, height: 0.5)
        cardViewContainer.layer.shadowOpacity = 0.7
        cardViewContainer.layer.shadowRadius = 7
        cardViewContainer.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.cornerRadius = 12
        cardBackgroundView.clipsToBounds = true
        title.font = .pretendard(size: 30, weight: .bold)
        title.numberOfLines = 2
        title.textAlignment = .center
        numberOfQuizs.font = .pretendard(size: 14, weight: .thin)
        playButton.backgroundColor = .white
        playButton.setTitle("PLAY", for: .normal)
        playButton.setTitleColor(.pointOrange, for: .normal)
        playButton.titleLabel?.font = .pretendard(size: 30, weight: .extraBold)
        playButton.layer.cornerRadius = 30
        playButton.layer.borderWidth = 5
        playButton.layer.borderColor = UIColor.pointOrange.cgColor
        indexLabel.font = .pretendard(size: 15, weight: .regular)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .pointOrange
    }
    
    func setUI(_ package: RealmPosterQuizPackage) {
        title.text = package.title
        guard let detailURL = package.quizs.last?.poster else { return }
        let url = PosterURL.thumbnailURL(detailURL: detailURL).endpoint
        let processor = BlurImageProcessor(blurRadius: 20.0)
        posterView.kf.setImage(with: url, options: [.processor(processor)])
        numberOfQuizs.text = "\(package.numberOfQuiz)문제"
        levelImage.image = {
            switch package.level {
            case 0:
                return UIImage(named: "Begginer")
            case 1:
                return UIImage(named: "Intermediate")
            case 2:
                return UIImage(named: "Expert")
            default:
                return UIImage(named: "Begginer")
            }
        }()
        makerNickname.text = package.makerInfo?.nickname
    }
    
    func setProfile(profileImage: UIImage?) {
        guard let profileImage = profileImage else {
            makerProfile.image = .defaultAvatar
            return
        }
        makerProfile.image = profileImage
    }
    
    func setIndexLabel(index: String) {
        indexLabel.text = index
    }
    
}

extension QuizCardCollectionViewCell: TransformableView {
    
    var selectableView: UIView? {
        nil
    }
    
    func transform(progress: CGFloat) {
        transformCardView(progress: progress)
        transformBottomViews(progress: progress)
        
        let normalTransform = CGAffineTransform(translationX: bounds.width * progress, y: 0)
        title.transform = normalTransform
        numberOfQuizs.transform = normalTransform
        profileContainer.transform = normalTransform
    }
    
    private func transformBottomViews(progress: CGFloat) {
        let angle = .pi * progress
        var transform = CATransform3DIdentity
        transform.m34 = -0.008
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        indexLabel.layer.transform = transform
        indexLabel.alpha = abs(progress) > 0.5 ? 0 : 1
        deleteButton.layer.transform = transform
        deleteButton.alpha = abs(progress) > 0.5 ? 0 : 1
        playButton.layer.transform = transform
        playButton.alpha = abs(progress) > 0.5 ? 0 : 1
    }
    
    private func transformCardView(progress: CGFloat) {
        let translationX: CGFloat = bounds.width * progress
        
        let imageScale = 1 - abs(0.5 * progress)
        levelImage.transform = CGAffineTransform(translationX: translationX, y: progress * cardBackgroundView.frame.height / 8)
            .scaledBy(x: imageScale, y: imageScale)
        
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
