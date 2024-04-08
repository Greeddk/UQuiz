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
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let receiveButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([logoView, collectionView, receiveButton])
    }
    
    override func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-40)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        receiveButton.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        logoView.image = .uquizLogo
        logoView.contentMode = .scaleAspectFit
        receiveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        receiveButton.tintColor = .pointOrange
    }
    
    private func createLayout() -> CollectionViewPagingLayout {
        let layout = CollectionViewPagingLayout()
        layout.numberOfVisibleItems = 4
        return layout
    }
    
}
