//
//  SolvePosterAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation

final class SolvePosterAreaQuizViewModel {
    
    let repository = PosterQuizPackageRepository()
    
    var inputNextIndexTrigger: Observable<Void?> = Observable(nil)
    var inputAnswerSubmit: Observable<String?> = Observable(nil)
    
    var outputQuizList: Observable<[RealmPosterQuiz]> = Observable([])
    var outputCurrentIndex: Observable<Int> = Observable(0)
    var outputStatusString: Observable<String> = Observable("")
    var outputIsCorrect: Observable<Bool> = Observable(false)
    var outputGameOverStatus: Observable<Bool> = Observable(false)
    
    init() {
        inputNextIndexTrigger.noInitBind { _ in
            self.manageIndex()
        }
        inputAnswerSubmit.noInitBind { answer in
            self.markingAnswer(answer)
        }
    }
    
    private func manageIndex() {
        if outputCurrentIndex.value == outputQuizList.value.count - 1 {
            self.outputGameOverStatus.value = true
        } else {
            self.outputCurrentIndex.value += 1
        }
    }
    
    private func markingAnswer(_ answer: String?) {
        guard let answer = answer else {
            outputStatusString.value = "정답을 입력해주세요"
            return
        }
        let correctAnswer = outputQuizList.value[outputCurrentIndex.value].title.lowercased()
        if correctAnswer == answer.lowercased() {
            outputIsCorrect.value = true
            repository.updateQuizIsCorrect(outputQuizList.value[outputCurrentIndex.value], isCorrect: true)
        } else {
            outputIsCorrect.value = false
            repository.updateQuizIsCorrect(outputQuizList.value[outputCurrentIndex.value], isCorrect: false)
        }
    }
    
}
