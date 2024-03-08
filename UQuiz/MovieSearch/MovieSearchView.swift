//
//  MovieSearchView.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit
import SnapKit

class MovieSearchView: BaseView {
    
    let searchBar = UISearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubviews([searchBar])
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "MovieSearchView_placeholder".localized
    }

}
