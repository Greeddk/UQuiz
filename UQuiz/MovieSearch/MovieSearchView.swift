//
//  MovieSearchView.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit
import SnapKit

final class MovieSearchView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
    let searchBar = UISearchBar()
    private var cellWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellWidth = (self.frame.width - 30) / 2
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    
    override func configureHierarchy() {
        addSubviews([searchBar, collectionView])
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
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
        return layout
    }
    
}
