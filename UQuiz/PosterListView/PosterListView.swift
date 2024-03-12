//
//  PosterListView.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import UIKit
import SnapKit

final class PosterListView: BaseView {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var screenWidth: CGFloat = 0
    
    override func layoutSubviews() {
        screenWidth = self.frame.width
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (screenWidth - 40) / 3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        }
    }
    
    override func configureHierarchy() {
        addSubviews([collectionView])
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

}
