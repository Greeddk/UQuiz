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
        hideKeyboardWhenViewIsTapped()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardEvent()
        viewModel.outputIsCorrect.noInitBind { value in
            self.judgeValue(value: value)
        }
        viewModel.outputStatusString.noInitBind { text in
            self.showAlert(title: "", message: text, okTitle: "확인") { }
        }
        viewModel.outputGameOverStatus.noInitBind { value in
            let vc = QuizResultViewController()
            vc.viewModel.inputData.value = self.viewModel.outputQuizList.value
            self.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.outputCurrentPercentage.bind { value in
            self.mainView.updateTimeLimitBar(value)
        }
        viewModel.outputTimeOverStatus.noInitBind { _ in
            self.timeOverAction()
        }
        viewModel.inputSetTimerTrigger.value = ()
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mainView.submitButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
        mainView.answerTextField.delegate = self
        let detailURL = viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].poster
        mainView.fetchPoster(detailURL: detailURL)
        setNavigationBackButton()
        navigationItem.title = info
        navigationController?.navigationBar.backgroundColor = .test
    }
    
    override func backButtonClicked() {
        super.backButtonClicked()
        self.viewModel.inputInvalidTimerTrigger.value = ()
    }
    
}

// MARK: Private Func
extension SolvePosterAreaQuizViewController {
    
    // MARK: 시간 초과시 알러트
    private func timeOverAction() {
        mainView.setTextFieldAndButtonEnable(isEnabled: false)
        self.showAlert(title: "시간초과", message: "5초 동안 포스터를 공개하고 다음으로 넘어갑니다", okTitle: "확인") {
            self.mainView.answerTextField.text = self.viewModel.outputQuizList.value[self.viewModel.outputCurrentIndex.value].title
            self.mainView.collectionView.isHidden = true
            self.resetTimeLimitBar()
            self.goNext()
        }
        createImojiRainParticles()
    }
    
    private func resetTimeLimitBar() {
        UIView.animate(withDuration: 5.5, animations: {
            self.viewModel.inputTimeLimitBarPercentage.value = 0
        })
    }
    
    // MARK: 다음 퀴즈 fetch
    private func goNext() {
        let timeDelay: DispatchTimeInterval = .seconds(5)
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
    
    @objc
    private func submitButtonClicked() {
        viewModel.inputAnswerSubmit.value = mainView.answerTextField.text
    }
    
    // MARK: 정답 / 오답 판별
    private func judgeValue(value: Bool) {
        if value {
            mainView.setTextFieldAndButtonEnable(isEnabled: false)
            viewModel.inputInvalidTimerTrigger.value = ()
            showAlert(title: "정답", message: "5초 동안 포스터를 공개하고 다음으로 넘어갑니다", okTitle: "확인") {
                self.mainView.answerTextField.text = self.viewModel.outputQuizList.value[self.viewModel.outputCurrentIndex.value].title
                self.mainView.collectionView.isHidden = true
                self.resetTimeLimitBar()
                self.goNext()
            }
            createCongratsParticles()
        } else {
            mainView.posterView.shake()
            mainView.collectionView.shake()
            mainView.answerTextField.shake()
            mainView.submitButton.shake()
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
        let flattenedList = list.flatMap { $0.area }
        for index in flattenedList {
            let cell = mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.backgroundColor = .clear
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
        let selectedArea = Array(viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].selectedArea).flatMap { data in
            data.area
        }
        //TODO: 차례대로 나타나게 하기
        if selectedArea.contains(indexPath.item) {
            cell.backgroundColor = .clear
        } else {
            cell.backgroundColor = .black
        }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitterLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
        
        let centerPoint = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        print(centerPoint)
        emitterLayer.emitterPosition = CGPoint(x: centerPoint.x, y: centerPoint.y)
        emitterLayer.birthRate = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitterLayer.birthRate = 0
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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

