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
    
    var inputTimeLimitBarPercentage: Observable<Float> = Observable(0)
    var inputNextIndexTrigger: Observable<Void?> = Observable(nil)
    var inputAnswerSubmit: Observable<String?> = Observable(nil)
    var inputSetTimerTrigger: Observable<Void?> = Observable(nil)
    var inputInvalidTimerTrigger: Observable<Void?> = Observable(nil)
    var inputLevel: Observable<Int> = Observable(0)
    var inputPauseButtonTapped: Observable<Void?> = Observable(nil)
    var inputResumeActionTrigger: Observable<Void?> = Observable(nil)
    var inputResetTimerTrigger: Observable<Void?> = Observable(nil)
    var inputIsShowAnswer: Observable<Bool> = Observable(false)
    
    var outputCurrentPercentage: Observable<Float> = Observable(0)
    var outputQuizList: Observable<[RealmPosterQuiz]> = Observable([])
    var outputCurrentIndex: Observable<Int> = Observable(0)
    var outputStatusString: Observable<String> = Observable("")
    var outputIsCorrect: Observable<Bool> = Observable(false)
    var outputTimeOverStatus: Observable<Void?> = Observable(nil)
    var outputGameOverStatus: Observable<Bool> = Observable(false)
    var outputIsPaused: Observable<Bool> = Observable(false)
    var outputIsShowAnswer: Observable<Bool> = Observable(false)
    var outputGoNextTrigger: Observable<Void?> = Observable(nil)

    init() {
        inputSetTimerTrigger.bind { [weak self] _ in
            self?.setTimer()
        }
        inputInvalidTimerTrigger.bind { [weak self] _ in
            self?.stopTimer()
        }
        inputTimeLimitBarPercentage.bind { [weak self] value in
            self?.outputCurrentPercentage.value = value
        }
        inputNextIndexTrigger.noInitBind { [weak self] _ in
            self?.manageIndex()
        }
        inputAnswerSubmit.noInitBind { [weak self] answer in
            self?.markingAnswer(answer)
        }
        inputPauseButtonTapped.noInitBind { [weak self] _ in
            self?.updateIsPauseValue(true)
        }
        inputResumeActionTrigger.noInitBind { [weak self] _ in
            self?.updateIsPauseValue(false)
        }
        inputResetTimerTrigger.noInitBind { [weak self] _ in
            self?.resetTimer()
        }
        inputIsShowAnswer.noInitBind { [weak self] value in
            self?.outputIsShowAnswer.value = value
        }
    }
    
    private func updateIsPauseValue(_ isPaused: Bool) {
        outputIsPaused.value = isPaused
        if isPaused {
            stopTimer()
        } else {
            if outputIsShowAnswer.value {
                resetTimer()
            } else {
                resumeTimer()
            }
        }
    }
    
    private func setTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.outputCurrentPercentage.value += 1/2000
            if self.outputCurrentPercentage.value >= 1 {
                self.inputInvalidTimerTrigger.value = ()
                self.outputTimeOverStatus.value = ()
            }
        }
    }
    
    private func resetTimer() {
        let savedValue = self.outputCurrentPercentage.value
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.outputCurrentPercentage.value -= (1 / 300) * savedValue
            if self.outputCurrentPercentage.value <= 0 {
                self.inputInvalidTimerTrigger.value = ()
                self.outputCurrentPercentage.value = 0
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
            outputStatusString.value = "SolvePosterVM_NoAnswerMessage".localized
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
