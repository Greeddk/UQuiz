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
    var info: String = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenViewIsTapped()
        viewModel.outputIsCorrect.noInitBind { value in
            self.judgeValue(value: value)
        }
        viewModel.outputStatusString.noInitBind { text in
            self.showAlert(title: "", message: text, okTitle: "확인") { }
        }
        viewModel.outputGameOverStatus.noInitBind { value in
            let vc = QuizResultViewController()
            vc.viewModel.inputData.value = self.viewModel.outputQuizList.value
            vc.viewModel.inputLevel.value = self.viewModel.inputLevel.value
            self.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.outputCurrentPercentage.bind { value in
            self.mainView.updateTimeLimitBar(value)
        }
        viewModel.outputTimeOverStatus.noInitBind { _ in
            self.timeOverAction()
        }
        viewModel.outputCurrentIndex.bind { _ in
            self.checkQuizCount()
        }
        viewModel.outputIsPaused.bind { isPaused in
            self.mainView.setUIWhenPaused(isPaused: isPaused)
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
    }
    
}

// MARK: Private Func
extension SolvePosterAreaQuizViewController {
    
    @objc private func pauseButtonTapped() {
        viewModel.inputPauseButtonTapped.value = ()
        let vc = PauseModalViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.resumeCompletionHandler = {
            self.viewModel.inputPauseButtonTapped.value = ()
        }
        vc.exitCompletionHandler = {
            self.viewModel.inputInvalidTimerTrigger.value = ()
            self.navigationController?.popViewController(animated: true)
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
        self.showAlert(title: "시간초과", message: "3초 동안 포스터를 공개하고 다음으로 넘어갑니다", okTitle: "확인") {
            self.mainView.answerTextField.text = self.viewModel.outputQuizList.value[self.viewModel.outputCurrentIndex.value].title
            self.mainView.collectionView.isHidden = true
            self.resetTimeLimitBar()
            self.goNext()
        }
        createImojiRainParticles()
    }
    
    private func resetTimeLimitBar() {
        UIView.animate(withDuration: 3.5, animations: {
            self.viewModel.inputTimeLimitBarPercentage.value = 0
        })
    }
    
    // MARK: 다음 퀴즈 fetch
    private func goNext() {
        let timeDelay: DispatchTimeInterval = .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            self.viewModel.inputNextIndexTrigger.value = ()
            self.fetchPoster()
            self.fetchCollectionViewSelectedArea()
            self.mainView.setTextFieldAndButtonEnable(isEnabled: true)
            self.mainView.clearTextField()
            if !self.viewModel.outputGameOverStatus.value {
                self.viewModel.inputSetTimerTrigger.value = ()
            }
        }
    }
    
    // MARK: 정답 스킵하고 넘어가기
    private func skipAnswer() {
        self.viewModel.inputNextIndexTrigger.value = ()
        self.viewModel.inputTimeLimitBarPercentage.value = 0
        self.fetchPoster()
        self.fetchCollectionViewSelectedArea()
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
            let alert = UIAlertController(title: "정답", message: "3초 동안 포스터를 공개하고 다음으로 넘어갑니다. 스킵하고 싶다면 스킵해주세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.mainView.answerTextField.text = self.viewModel.outputQuizList.value[self.viewModel.outputCurrentIndex.value].title
                self.mainView.collectionView.isHidden = true
                self.resetTimeLimitBar()
                self.goNext()
            }
            let skip = UIAlertAction(title: "Skip", style: .default) { _ in
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
        let list =  Array(viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].selectedArea)
        let level = viewModel.inputLevel.value
        var delay: TimeInterval = 0
        
        for array in list {
            let areaIndex = Array(array.area)
            UIView.animate(withDuration: 2, delay: delay, options: [], animations: {
                for index in areaIndex {
                    let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                    cell?.backgroundColor = .clear
                }
            }, completion: nil)
            delay += Double(level) + 2
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

