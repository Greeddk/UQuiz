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
