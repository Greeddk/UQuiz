//
//  MovieCardCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/20/24.
//

import UIKit
import SnapKit

final class MovieCardCollectionViewCell: BaseCollectionViewCell {
    
    let containverView = UIView()
    let posterView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let releaseData = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubviews([containverView, posterView, titleLabel, overviewLabel, releaseData])
    }
    
    override func setConstraints() {
        containverView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        posterView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(containverView).inset(10)
        }
    }
    
    override func configureView() {
        containverView.layer.cornerRadius = 12
    }
    
}
