//
//  BaseCollectionViewCell.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureHierarchy()
        setConstraints()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    
    func configureView() {
        
    }
    
    func setConstraints() {
        
    }
    
}
