//
//  SolvePosterAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation

final class SolvePosterAreaQuizViewModel {
    
    var inputCurrentIndex: Observable<Int> = Observable(0)
    
    var outputQuizList: Observable<[RealmPosterQuiz]> = Observable([])
    var outputCurrentIndex: Observable<Int> = Observable(0)
    
    init() {
        inputCurrentIndex.bind { value in
            self.outputCurrentIndex.value = value
        }
    }
    
}
