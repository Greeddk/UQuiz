//
//  SolvePosterAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation

protocol timerDelegate: AnyObject {
    func stopTimer()
    func resumeTimer()
}

final class SolvePosterAreaQuizViewModel {
    
    let repository = PosterQuizPackageRepository()
    
    var timer = Timer()
    var isPaused: Bool = false
    
    var inputTimeLimitBarPercentage: Observable<Float> = Observable(0)
    var inputNextIndexTrigger: Observable<Void?> = Observable(nil)
    var inputAnswerSubmit: Observable<String?> = Observable(nil)
    var inputSetTimerTrigger: Observable<Void?> = Observable(nil)
    var inputInvalidTimerTrigger: Observable<Void?> = Observable(nil)
    var inputLevel: Observable<Int> = Observable(0)
    var inputPauseButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputCurrentPercentage: Observable<Float> = Observable(0)
    var outputQuizList: Observable<[RealmPosterQuiz]> = Observable([])
    var outputCurrentIndex: Observable<Int> = Observable(0)
    var outputStatusString: Observable<String> = Observable("")
    var outputIsCorrect: Observable<Bool> = Observable(false)
    var outputTimeOverStatus: Observable<Void?> = Observable(nil)
    var outputGameOverStatus: Observable<Bool> = Observable(false)
    var outputIsPaused: Observable<Bool> = Observable(false)
    
    init() {
        inputSetTimerTrigger.bind { _ in
            self.setTimer()
        }
        inputInvalidTimerTrigger.bind { _ in
            self.stopTimer()
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
        inputPauseButtonTapped.noInitBind { _ in
            self.togglePause()
        }
    }
    
    private func togglePause() {
        isPaused.toggle()
        outputIsPaused.value = isPaused
        if isPaused {
            stopTimer()
        } else {
            resumeTimer()
        }
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.outputCurrentPercentage.value += 1/2000
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
        let quizItem = outputQuizList.value[outputCurrentIndex.value]
        let correctAnswer = quizItem.title.matchString(quizItem.title).lowercased()
        let originAnswer = quizItem.original_title.matchString(quizItem.original_title).lowercased()
        let changedUserAnswer = answer.matchString(answer).lowercased()
        if correctAnswer == changedUserAnswer || originAnswer == changedUserAnswer {
            outputIsCorrect.value = true
            repository.updateQuizIsCorrect(outputQuizList.value[outputCurrentIndex.value], isCorrect: true)
        } else {
            outputIsCorrect.value = false
            repository.updateQuizIsCorrect(outputQuizList.value[outputCurrentIndex.value], isCorrect: false)
        }
    }
    
}

extension SolvePosterAreaQuizViewModel: timerDelegate {
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func resumeTimer() {
        setTimer()
    }
    
}
