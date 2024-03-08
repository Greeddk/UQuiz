//
//  UIView+Extension.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

