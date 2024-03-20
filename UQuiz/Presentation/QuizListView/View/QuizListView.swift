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
    
    let logoView = UIImageView()
    let deleteButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubviews([logoView, deleteButton, collectionView])
    }
    
    override func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.top.equalTo(self).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoView)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        logoView.image = .uqizlogo
        logoView.contentMode = .scaleAspectFit
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .pointOrange
    }
    
    private func createLayout() -> CollectionViewPagingLayout {
        let layout = CollectionViewPagingLayout()
        return layout
    }
    
}
