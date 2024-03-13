//
//  Observable.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

final class Observable<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func noInitBind(_ closure: @escaping (T) -> Void) {
        self.closure = closure
    }
    
}
