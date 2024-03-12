//
//  MakeMovieAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import Foundation

final class MakeMovieAreaQuizViewModel {
    
    var inputQuizPackage: Observable<[Movie]> = Observable([])
    var inputIndex: Observable<Int> = Observable(0)
    
    var outputQuizPackage: Observable<[Movie]> = Observable([])
    var currentIndex: Observable<Int> = Observable(0)
    
    init() {
        inputQuizPackage.bind { value in
            self.outputQuizPackage.value = value
        }
        inputIndex.bind { value in
            self.currentIndex.value = value
        }
    }
    
}
