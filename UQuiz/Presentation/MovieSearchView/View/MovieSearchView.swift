//
//  MovieSearchView.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit
import SnapKit

final class MovieSearchView: BaseView {
    
    let logoView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
    let searchBar = UISearchBar()
    private var cellWidth: CGFloat = 0
    
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
        addSubviews([logoView, searchBar, collectionView])
    }
    
    override func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-40)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
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
        logoView.image = .uquizLogo
        logoView.contentMode = .scaleAspectFit
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "MovieSearchView_placeholder".localized
    }

    private func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }
    
}
