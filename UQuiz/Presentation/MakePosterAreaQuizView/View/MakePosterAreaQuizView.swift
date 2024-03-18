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
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        
        showPostersButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        nextMovieButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
    override func configureView() {
        previousMovieButton.setTitle("이전 영화", for: .normal)
        previousMovieButton.setTitleColor(.black, for: .normal)
        previousMovieButton.backgroundColor = .blue
        showPostersButton.setTitle("다른 포스터", for: .normal)
        showPostersButton.setTitleColor(.black, for: .normal)
        showPostersButton.backgroundColor = .green
        nextMovieButton.setTitle("다음 영화", for: .normal)
        nextMovieButton.setTitleColor(.black, for: .normal)
        nextMovieButton.backgroundColor = .red
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