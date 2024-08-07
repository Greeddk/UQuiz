//
//  SolvePosterAreaQuizViewController.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import UIKit

final class SolvePosterAreaQuizViewController: BaseViewController {
    
    let mainView = SolvePosterAreaQuizView()
    let viewModel = SolvePosterAreaQuizViewModel()
    
    var animators: [UIViewPropertyAnimator] = []
    var animatorProgress: [CGFloat] = []
    var showAnswerAnimation: UIViewPropertyAnimator?
    var answerTimeAnimation: UIViewPropertyAnimator?
    var answerTimeProgress: CGFloat = 0
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenViewIsTapped()
        
        viewModel.outputIsCorrect.noInitBind { [weak self] value in
            self?.judgeValue(value: value)
        }
        viewModel.outputStatusString.noInitBind { [weak self] text in
            self?.showAlert(title: "", message: text, okTitle: "ExtensionVC_AlertOK".localized) { }
        }
        viewModel.outputGameOverStatus.noInitBind { [weak self] value in
            guard let self = self else { return }
            let vc = QuizResultViewController()
            vc.viewModel.inputData.value = self.viewModel.outputQuizList.value
            vc.viewModel.inputLevel.value = self.viewModel.inputLevel.value
            self.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.outputCurrentPercentage.bind { [weak self] value in
            self?.mainView.updateTimeLimitBar(value)
        }
        viewModel.outputTimeOverStatus.noInitBind { [weak self] _ in
            self?.timeOverAction()
        }
        viewModel.outputCurrentIndex.bind { [weak self] _ in
            self?.checkQuizCount()
        }
        viewModel.outputIsPaused.bind { [weak self] isPaused in
            guard let self = self else { return }
            self.mainView.setUIWhenPaused(isPaused: isPaused, isShowAnswer: self.viewModel.outputIsShowAnswer.value)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCollectionViewSelectedArea()
        viewModel.inputSetTimerTrigger.value = ()
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mainView.answerTextField.delegate = self
        mainView.pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        let detailURL = viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].poster
        mainView.fetchPoster(detailURL: detailURL)
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(sceneResignStatusNotification), name: NSNotification.Name("SceneResign"), object: nil)
    }
    
}

// MARK: Private Func
extension SolvePosterAreaQuizViewController {
    
    // MARK: NotificationCenter (백그라운드 상태로 변화할때)
    @objc private func sceneResignStatusNotification(notification: NSNotification) {
        if let value = notification.userInfo?["willResign"] as? Bool {
            if value {
                pauseButtonTapped()
            }
        }
    }
    
    // MARK: 일시정지 기능
    @objc private func pauseButtonTapped() {
        if !viewModel.outputIsPaused.value {
            viewModel.inputPauseButtonTapped.value = ()
            presentPauseModalView()
            if viewModel.outputIsShowAnswer.value {
                showAnswerAnimation?.stopAnimation(false)
                showAnswerAnimation?.finishAnimation(at: .current)
                guard let animator = answerTimeAnimation else { return }
                answerTimeProgress = animator.fractionComplete
            } else {
                pauseAnimations()
            }
        }
    }
    
    private func resumeShowAnswer() {
        self.viewModel.inputResumeActionTrigger.value = ()
        self.showAnswerAnimation?.startAnimation()
        let restTime = 3 * (1 - answerTimeProgress)
        showAnswerAnimation = UIViewPropertyAnimator(duration: restTime, curve: .easeIn) {
            self.resetCollectionView()
        }
        showAnswerAnimation?.startAnimation()
        showAnswerAnimation?.addCompletion { [weak self] position in
            guard let self = self else { return }
            if position == .end {
                self.viewModel.inputNextIndexTrigger.value = ()
                self.fetchCollectionViewSelectedArea()
                self.fetchPoster()
                self.mainView.setTextFieldAndButtonEnable(isEnabled: true)
                self.mainView.clearTextField()
                if !self.viewModel.outputGameOverStatus.value {
                    self.viewModel.inputSetTimerTrigger.value = ()
                }
                self.viewModel.outputIsShowAnswer.value = false
            }
        }
    }
    
    private func resumeQuiz() {
        self.viewModel.inputResumeActionTrigger.value = ()
        self.resumeAnimations()
    }
    
    private func presentPauseModalView() {
        let vc = PauseModalViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.resumeCompletionHandler = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.outputIsShowAnswer.value {
                self.resumeShowAnswer()
            } else {
                self.resumeQuiz()
            }
        }
        vc.exitCompletionHandler = { [weak self] in
            guard let self = self else { return }
            self.viewModel.inputInvalidTimerTrigger.value = ()
            self.navigationController?.popToRootViewController(animated: true)
        }
        present(vc, animated: true)
    }
    
    // MARK: 퀴즈 남은 개수
    private func checkQuizCount() {
        mainView.setQuizCount(currentIndex: viewModel.outputCurrentIndex.value + 1, totalIndex: viewModel.outputQuizList.value.count)
    }
    
    // MARK: 시간 초과시 알러트
    private func timeOverAction() {
        mainView.setTextFieldAndButtonEnable(isEnabled: false)
        self.showAlert(title: "SolvePosterVC_Time'sUpTitle".localized, message: "SolvePosterVC_Time'sUpMessage".localized, okTitle: "ExtensionVC_AlertOK".localized) { [weak self] in
            guard let self = self else { return }
            self.viewModel.outputIsShowAnswer.value = true
            self.mainView.answerTextField.text = self.viewModel.outputQuizList.value[self.viewModel.outputCurrentIndex.value].title
            self.finishAnimations()
            self.mainView.collectionView.isHidden = true
            self.resetTimeLimitBar()
            self.goNext()
        }
        createImojiRainParticles()
    }
    
    private func resetTimeLimitBar() {
        viewModel.inputResetTimerTrigger.value = ()
    }
    
    // MARK: 다음 퀴즈 fetch
    private func goNext() {
        showAnswerAnimation = UIViewPropertyAnimator(duration: 3, curve: .easeIn) {
            self.resetCollectionView()
        }
        showAnswerAnimation?.startAnimation()
        showAnswerAnimation?.addCompletion { [weak self] position in
            guard let self = self else { return }
            if position == .end {
                self.viewModel.inputNextIndexTrigger.value = ()
                self.fetchCollectionViewSelectedArea()
                self.fetchPoster()
                self.mainView.setTextFieldAndButtonEnable(isEnabled: true)
                self.mainView.clearTextField()
                if !self.viewModel.outputGameOverStatus.value {
                    self.viewModel.inputSetTimerTrigger.value = ()
                }
                self.viewModel.outputIsShowAnswer.value = false
            }
        }
    }
    
    // MARK: 정답 스킵하고 넘어가기
    private func skipAnswer() {
        self.viewModel.inputNextIndexTrigger.value = ()
        self.viewModel.inputTimeLimitBarPercentage.value = 0
        self.fetchCollectionViewSelectedArea()
        self.fetchPoster()
        self.mainView.setTextFieldAndButtonEnable(isEnabled: true)
        self.mainView.clearTextField()
        if !self.viewModel.outputGameOverStatus.value {
            self.viewModel.inputSetTimerTrigger.value = ()
        }
    }
    
    // MARK: 정답 / 오답 판별
    private func judgeValue(value: Bool) {
        if value {
            mainView.setTextFieldAndButtonEnable(isEnabled: false)
            viewModel.inputInvalidTimerTrigger.value = ()
            let alert = UIAlertController(title: "SolvePosterVC_CorrectTitle".localized, message: "SolvePosterVC_CorrectMessage".localized, preferredStyle: .alert)
            let ok = UIAlertAction(title: "ExtensionVC_AlertOK".localized, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.outputIsShowAnswer.value = true
                self.mainView.answerTextField.text = self.viewModel.outputQuizList.value[self.viewModel.outputCurrentIndex.value].title
                self.finishAnimations()
                self.mainView.collectionView.isHidden = true
                self.resetTimeLimitBar()
                self.goNext()
            }
            let skip = UIAlertAction(title: "Skip", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.finishAnimations()
                self.skipAnswer()
            }
            alert.addAction(ok)
            alert.addAction(skip)
            present(alert, animated: true)
            createCongratsParticles()
        } else {
            mainView.posterView.shake()
            mainView.collectionView.shake()
            mainView.answerTextField.shake()
            self.mainView.clearTextField()
        }
    }
    
    // MARK: Poster 로드
    private func fetchPoster() {
        let url = viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].poster
        mainView.fetchPoster(detailURL: url)
    }
    
    // MARK: CollectionView 선택 영역 표시
    private func fetchCollectionViewSelectedArea() {
        mainView.collectionView.isHidden = false
        resetCollectionView()
        startAreaAnimation()
    }
    
    private func startAreaAnimation() {
        let list = Array(viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].selectedArea)
        let level = viewModel.inputLevel.value
        animatorProgress = Array(repeating: 0, count: list.count)
        
        for array in list {
            let areaIndex = Array(array.area)
            
            let animator = UIViewPropertyAnimator(duration: TimeInterval(2 + level / 2), curve: .linear) { [weak self] in
                guard let self = self else { return }
                for index in areaIndex {
                    let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                    cell?.backgroundColor = .clear
                }
            }
            animators.append(animator)
        }
        startNextAnimation(index: 0)
    }
    
    private func startNextAnimation(index: Int) {
        guard index < animators.count else { return }
        
        let animator = animators[index]
        animator.startAnimation()
        
        animator.addCompletion { [weak self] position in
            guard let self = self else { return }
            guard position == .end else { return }
            
            self.startNextAnimation(index: index + 1)
        }
    }

    private func pauseAnimations() {
        for (index, animator) in animators.enumerated() {
            animatorProgress[index] = animator.fractionComplete
            animator.stopAnimation(true)
        }
    }
    
    private func finishAnimations() {
        for (_, animator) in animators.enumerated() {
            animator.stopAnimation(true)
        }
        animators = []
    }
    
    private func resumeAnimations() {
        
        guard let lastIndex = animatorProgress.firstIndex(where: { $0 != 0 }) else { return }
        let nextIndex = lastIndex + 1
        let list = Array(viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].selectedArea)
        let level = viewModel.inputLevel.value
        let listLastIndex = list.count - 1
        
        // lastIndex의 보이는 정도 복구
        for index in Array(list[lastIndex].area) {
            let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.backgroundColor = .black.withAlphaComponent(1 - animatorProgress[lastIndex])
        }
        
        if lastIndex < listLastIndex {
            // 아직 안보이는 부분 검은색으로 다시 칠하기 / 애니메이션 주기
            for restIndex in lastIndex + 1...listLastIndex {
                let areaList = list[restIndex]
                let areaIndex = Array(areaList.area)
                for index in areaIndex {
                    let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                    cell?.backgroundColor = .black
                }
                let animator = UIViewPropertyAnimator(duration: TimeInterval(2 + level / 2), curve: .linear) { [weak self] in
                    guard let self = self else { return }
                    for index in areaIndex {
                        let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                        cell?.backgroundColor = .clear
                    }
                }
                animators[restIndex] = animator
            }
        }
        
        // lastIndex 애니메이션 주기
        let restTime: CGFloat = CGFloat((2 + level / 2)) * (1 - animatorProgress[lastIndex])
        let animator = UIViewPropertyAnimator(duration: Double(restTime), curve: .linear) { [weak self] in
            guard let self = self else { return }
            for index in Array(list[lastIndex].area) {
                let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                cell?.backgroundColor = .clear
            }
        }
        animators[lastIndex] = animator
        
        animators[lastIndex].startAnimation()
        animators[lastIndex].addCompletion { [weak self] position in
            guard let self = self else { return }
            if position == .end {
                self.startNextAnimation(index: nextIndex)
            }
        }
    }
    
    // MARK: CollectionView 초기화
    private func resetCollectionView() {
        for index in 0...3749 {
            let cell = mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.backgroundColor = .black
        }
    }
}

// MARK: CollectionView Setting
extension SolvePosterAreaQuizViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3750
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
}

// MARK: TextField Setting
extension SolvePosterAreaQuizViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        viewModel.inputAnswerSubmit.value = mainView.answerTextField.text
        return true
    }
    
}

// MARK: 정답 / 오답 애니메이션
extension SolvePosterAreaQuizViewController {
    
    func createImojiRainParticles() {
        let cell = CAEmitterCell()
        cell.contents = "🤣".textToImage()!.cgImage
        cell.birthRate = 5
        cell.lifetime = 10
        cell.scale = 0.1
        cell.yAcceleration = 100
        cell.alphaSpeed = -0.1
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: view.frame.width,
                                          height: view.frame.height)
        emitterLayer.emitterPosition = CGPoint(x: view.center.x,
                                               y: .zero)
        emitterLayer.emitterCells = [cell]
        emitterLayer.birthRate = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            emitterLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            emitterLayer.removeFromSuperlayer()
        }
        
        view.layer.addSublayer(emitterLayer)
    }
    
    func createCongratsParticles() {
        let emitterLayer = CAEmitterLayer()
        let heart = makeEmitterCells(imoji: "😍")
        let popper = makeEmitterCells(imoji: "🎉")
        let movie = makeEmitterCells(imoji: "🎬")
        let popcorn = makeEmitterCells(imoji: "🍿")
        let thumbup = makeEmitterCells(imoji: "👍")
        
        emitterLayer.emitterCells = [heart, popper, movie, popcorn, thumbup]
        
        emitterLayer.emitterPosition = CGPoint(x: view.center.x, y: view.center.y)
        emitterLayer.birthRate = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            emitterLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            emitterLayer.removeFromSuperlayer()
        }
        view.layer.addSublayer(emitterLayer)
    }
    
    func makeEmitterCells(imoji: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        let image = imoji.textToImage()!
        cell.contents = image.cgImage
        
        cell.lifetime = 3
        cell.birthRate = 20
        
        cell.scale = 0.15
        cell.scaleRange = 0.05
        
        cell.spin = 5
        cell.spinRange = 10
        
        cell.emissionRange = CGFloat.pi * 2
        
        cell.velocity = 1000
        cell.velocityRange = 100
        cell.yAcceleration = 1000
        
        return cell
    }
    
}

