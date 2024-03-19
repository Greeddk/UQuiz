//
//  String+Extension.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(text: String) -> String {
        return String(format: self.localized, text)
    }
    
}

extension String {
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: CGFloat.random(in: 50...80))
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }
}

// MARK: 정규화
extension String {
    
    func matchString (_ text: String) -> String {
        let strArr = Array(text)
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-z0-9]$"
        var resultString = ""
        
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count {
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1
                    } else {
                        resultString += String(strArr[index])
                        index += 1
                    }
                }
            }
            return resultString
        } else {
            return text
        }
    }
    
}
