//
//  MovieInfoCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/10/24.
//

import UIKit
import Kingfisher

final class MovieInfoCollectionViewCell: BaseCollectionViewCell {
    
    let posterImage = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    let addToPackageButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    let movieTitle = {
        let view = UILabel()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.opacity = 0.8
        view.layer.cornerRadius = 4
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubviews([posterImage, addToPackageButton, movieTitle])
    }
    
    override func setConstraints() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        addToPackageButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        movieTitle.snp.makeConstraints { make in
            make.bottom.equalTo(posterImage.snp.bottom).inset(4)
            make.trailing.equalTo(posterImage.snp.trailing).inset(4)
            make.leading.greaterThanOrEqualTo(posterImage.snp.leading).offset(4)
        }
    }
    
    func configureCell(movieItem: Movie) {
        guard let poster = movieItem.poster else { return }
        let url = URL(string: PosterbaseURL.baseUrl + poster)
        posterImage.kf.setImage(with: url)
        movieTitle.text = " " + movieItem.title + " "
    }
    
}
