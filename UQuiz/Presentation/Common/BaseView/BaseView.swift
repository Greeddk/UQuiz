//
//  BaseView.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        setConstraints()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    
    func setConstraints() { }
    
    func configureView() { }

}

