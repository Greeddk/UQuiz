//
//  SolvePosterAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation

final class SolvePosterAreaQuizViewModel {
    
    let repository = PosterQuizPackageRepository()
    
    var timer = Timer()
    
    var inputTimeLimitBarPercentage: Observable<Float> = Observable(0)
    var inputNextIndexTrigger: Observable<Void?> = Observable(nil)
    var inputAnswerSubmit: Observable<String?> = Observable(nil)
    var inputSetTimerTrigger: Observable<Void?> = Observable(nil)
    var inputInvalidTimerTrigger: Observable<Void?> = Observable(nil)
    
    var outputCurrentPercentage: Observable<Float> = Observable(0)
    var outputQuizList: Observable<[RealmPosterQuiz]> = Observable([])
    var outputCurrentIndex: Observable<Int> = Observable(0)
    var outputStatusString: Observable<String> = Observable("")
    var outputIsCorrect: Observable<Bool> = Observable(false)
    var outputTimeOverStatus: Observable<Void?> = Observable(nil)
    var outputGameOverStatus: Observable<Bool> = Observable(false)
    
    init() {
        inputSetTimerTrigger.bind { _ in
            self.setTimer()
        }
        inputInvalidTimerTrigger.bind { _ in
            self.timer.invalidate()
        }
        inputTimeLimitBarPercentage.bind { value in
            self.outputCurrentPercentage.value = value
        }
        inputNextIndexTrigger.noInitBind { _ in
            self.manageIndex()
        }
        inputAnswerSubmit.noInitBind { answer in
            self.markingAnswer(answer)
        }
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.outputCurrentPercentage.value += 1/2000
            print(self.outputCurrentPercentage.value)
            if self.outputCurrentPercentage.value >= 1 {
                self.inputInvalidTimerTrigger.value = ()
                self.outputTimeOverStatus.value = ()
            }
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
