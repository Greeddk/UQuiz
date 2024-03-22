//
//  MovieCardCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/20/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieCardCollectionViewCell: BaseCollectionViewCell {
    
    private let shadowView = UIView()
    private let containverView = UIView()
    private let posterView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let releaseLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubviews([shadowView])
        shadowView.addSubviews([containverView, posterView, titleLabel, overviewLabel, releaseLabel])
    }
    
    override func setConstraints() {
        containverView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
        releaseLabel.snp.makeConstraints { make in
            make.top.equalTo(containverView.snp.top).offset(2)
            make.trailing.equalTo(posterView.snp.trailing)
        }
        posterView.snp.makeConstraints { make in
            make.top.equalTo(releaseLabel.snp.bottom)
            make.centerX.equalTo(containverView)
            make.width.equalTo(240)
            make.height.equalTo(300)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(12)
            make.leading.equalTo(posterView.snp.leading)
        }
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(posterView.snp.trailing)
        }
    }
    
    override func configureView() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = .init(width: 0, height: 0.5)
        posterView.contentMode = .scaleToFill
        containverView.clipsToBounds = true
        containverView.layer.cornerRadius = 12
        containverView.backgroundColor = .white
        releaseLabel.font = .pretendard(size: 14, weight: .regular)
        titleLabel.font = .pretendard(size: 20, weight: .semiBold)
        overviewLabel.font = .pretendard(size: 16, weight: .regular)
        overviewLabel.numberOfLines = 4
    }
    
    func configureCell(movie: RealmPosterQuiz) {
        releaseLabel.text = movie.release_date
        let url = PosterURL.imageURL(detailURL: movie.poster).endpoint
        posterView.kf.setImage(with: url)
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
    
}
