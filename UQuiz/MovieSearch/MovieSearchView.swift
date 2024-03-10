//
//  MovieSearchView.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit
import SnapKit

class MovieSearchView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
    let addedMovieCountLabel = UILabel()
    let makeQuizPackageButton = UIButton()
    let searchBar = UISearchBar()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubviews([searchBar, collectionView, addedMovieCountLabel, makeQuizPackageButton])
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "MovieSearchView_placeholder".localized
    }

    private func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        DispatchQueue.main.async {
            //TODO: width 값 찾는 호출 방법 생각해보기
            let cellWidth = (self.frame.width - 30) / 2
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
        return layout
    }
}
