//
//  UILabel+Extension.swift
//  UQuiz
//
//  Created by Greed on 3/26/24.
//

import UIKit

extension UILabel {
    func asFontColor(targetStringList: [String], font: UIFont?, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)

        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        }
        attributedText = attributedString
    }
}
