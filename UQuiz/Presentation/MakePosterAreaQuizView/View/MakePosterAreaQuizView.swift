//
//  MakePosterAreaQuizView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit

final class MakePosterAreaQuizView: BaseView {
    
    let posterView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let previousMovieButton = UIButton()
    let nextMovieButton = UIButton()
    let showPostersButton = UIButton()
    private var screenWidth: CGFloat = 0
    
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
        addSubviews([posterView, collectionView, nextMovieButton, previousMovieButton, showPostersButton])
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
        previousMovieButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(90)
            make.height.equalTo(50)
        }
        showPostersButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        nextMovieButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(90)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        previousMovieButton.backgroundColor = .pointOrange
        previousMovieButton.setTitle("PREV", for: .normal)
        previousMovieButton.setTitleColor(.white, for: .normal)
        previousMovieButton.titleLabel?.font = .pretendard(size: 24, weight: .bold)
        previousMovieButton.layer.cornerRadius = 8
        showPostersButton.backgroundColor = .lightGreen
        showPostersButton.setTitle("MakePosterQuizView_ShowPostersButtonTitle".localized, for: .normal)
        showPostersButton.titleLabel?.font = .pretendard(size: 18, weight: .semiBold)
        showPostersButton.setTitleColor(.white, for: .normal)
        showPostersButton.layer.cornerRadius = 8
        nextMovieButton.backgroundColor = .pointOrange
        nextMovieButton.setTitle("NEXT", for: .normal)
        nextMovieButton.setTitleColor(.white, for: .normal)
        nextMovieButton.titleLabel?.font = .pretendard(size: 24, weight: .bold)
        nextMovieButton.layer.cornerRadius = 8
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
