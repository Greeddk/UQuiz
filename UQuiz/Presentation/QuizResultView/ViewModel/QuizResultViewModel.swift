//
//  QuizResultViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/17/24.
//

import Foundation

final class QuizResultViewModel {
    
    var inputData: Observable<[RealmPosterQuiz]> = Observable([])
    var inputLevel: Observable<Int> = Observable(0)
    
    var outputCorretRate: Observable<String> = Observable("")
    
    init() {
        inputData.bind { _ in
            self.makeStatistics()
        }
    }

    private func makeStatistics() {
        let totalData = inputData.value
        let correctData = inputData.value.filter { $0.isCorrect == true }
        outputCorretRate.value = "\(correctData.count) of \(totalData.count) "
    }
    
}
