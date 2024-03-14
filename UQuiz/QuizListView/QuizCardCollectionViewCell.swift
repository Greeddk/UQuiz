//
//  QuizCardCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout

class QuizCardCollectionViewCell: BaseCollectionViewCell {
    
    var card = UIView()
    var title = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(card)
        card.addSubviews([title])
    }
    
    override func setConstraints() {
        card.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(400)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(card.snp.top).offset(10)
        }
    }
    
    override func configureView() {
        card.backgroundColor = .systemOrange
        title.backgroundColor = .white
        title.text = "123124"
    }
}

extension QuizCardCollectionViewCell: SnapshotTransformView {

    var snapshotOptions: SnapshotTransformViewOptions {
        .layout(.chess)
    }
}
