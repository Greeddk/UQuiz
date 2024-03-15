//
//  MovieInfoCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/10/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieInfoCollectionViewCell: BaseCollectionViewCell {
    
    let posterImage = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    let addToPackageImage = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus.circle.fill")
        image.tintColor = .systemGray
        return image
    }()
    let gradientTitleBackView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let movieTitle = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([posterImage, addToPackageImage, gradientTitleBackView, movieTitle])
    }
    
    override func setConstraints() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        addToPackageImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        gradientTitleBackView.snp.makeConstraints { make in
            make.bottom.equalTo(posterImage.snp.bottom)
            make.horizontalEdges.equalTo(posterImage)
            make.height.equalTo(100)
        }
        
        movieTitle.snp.makeConstraints { make in
            make.bottom.equalTo(posterImage.snp.bottom).inset(4)
            make.leading.equalTo(posterImage.snp.leading).offset(8)
            make.trailing.greaterThanOrEqualTo(posterImage.snp.trailing).offset(-8)
        }
    }

    private func setupGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.9]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        DispatchQueue.main.async {
            gradient.frame = self.gradientTitleBackView.bounds
            self.gradientTitleBackView.layer.addSublayer(gradient)
        }
    }
    
    func configureCell(movieItem: Movie) {
        guard let poster = movieItem.poster else { return }
        let url = PosterURL.imageURL(detailURL: poster).endpoint
        posterImage.kf.setImage(with: url)
        movieTitle.text = movieItem.title
    }
    
    func fetchThumbnails(item: Poster) {
        let url = PosterURL.thumbnailURL(detailURL: item.poster).endpoint
        posterImage.kf.setImage(with: url)
        addToPackageImage.isHidden = true
    }
    
}
