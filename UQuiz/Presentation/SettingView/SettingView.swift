//
//  SettingView.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    //TODO: diffable로 바꿔보기
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubviews([collectionView])
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .clear
        configuration.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

}
