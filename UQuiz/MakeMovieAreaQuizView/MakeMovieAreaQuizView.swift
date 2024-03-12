//
//  MakeMovieAreaQuizView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit

final class MakeMovieAreaQuizView: BaseView {
    //TODO: 다음, 이전 버튼 그리고 다른 포스터로 바꾸기 버튼(모달)
    
    let resetButton = UIButton()
    let posterView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let nextButton = UIButton()
    private var screenWidth: CGFloat = 0
    let movieURL = "/8uUU2pxm6IYZw8UgnKJyx7Dqwu9.jpg"
    
    override func layoutSubviews() {
        screenWidth = (self.frame.width - 20)
        posterView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)

            make.width.equalTo(screenWidth)
            make.height.equalTo(screenWidth * 1.5)
        }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: screenWidth / 36, height: screenWidth / 36)
        }
    }
    
    override func configureHierarchy() {
        addSubviews([resetButton, posterView, collectionView, nextButton])
    }
    
    override func setConstraints() {
//        posterView.snp.makeConstraints { make in
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
//            make.centerX.equalTo(self.safeAreaLayoutGuide)
//            make.width.equalTo(360)
//            make.height.equalTo(540)
////            make.width.equalTo(screenWidth)
////            make.height.equalTo(screenWidth * 1.5)
//        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(posterView)
        }
    }
    
    override func configureView() {
        let url = PosterURL.imageURL(detailURL: movieURL).endpoint
        posterView.kf.setImage(with: url)
        posterView.contentMode = .scaleAspectFit
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.itemSize = CGSize(width: 10, height: 10)
        return layout
    }
    
}
