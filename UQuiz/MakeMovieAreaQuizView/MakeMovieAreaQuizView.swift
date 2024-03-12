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
    
    let posterView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let previousMovieButton = UIButton()
    let nextMovieButton = UIButton()
    let showPostersButton = UIButton()
    private var screenWidth: CGFloat = 0
    
    override func layoutSubviews() {
        screenWidth = (self.frame.width - 40)
        posterView.snp.updateConstraints { make in
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-50)
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
        addSubviews([posterView, collectionView, nextMovieButton, previousMovieButton, showPostersButton])
    }
    
    override func setConstraints() {
        posterView.snp.makeConstraints { make in
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-50)
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
