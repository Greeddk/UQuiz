//
//  QuizListView.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout

final class QuizListView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubviews([collectionView])
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func createLayout() -> CollectionViewPagingLayout {
        let layout = CollectionViewPagingLayout()
        return layout
    }
    
}
