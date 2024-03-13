//
//  QuizListView.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout

class QuizListView: BaseView {
    
    let title = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubviews([title, collectionView])
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .blue
        title.text = "test"
    }
    
    private func createLayout() -> CollectionViewPagingLayout {
        let layout = CollectionViewPagingLayout()
        layout.numberOfVisibleItems = 5
        return layout
    }
    
    
}
