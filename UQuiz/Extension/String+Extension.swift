//
//  String+Extension.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(text: String) -> String {
        return String(format: self.localized, text)
    }
    
}
