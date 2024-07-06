//
//  SolvePosterAreaQuizView.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SolvePosterAreaQuizView: BaseView {
    
    let quizCount = UILabel()
    let pauseButton = UIButton()
    let timerBackView = UIView()
    let timeLimitBar = UIProgressView(progressViewStyle: .default)
    let posterView = UIImageView()
    let pauseView = UIView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let answerTextField = UITextField()
    private var screenWidth: CGFloat = 0
    
    //MARK: layout
    override func layoutSubviews() {
        screenWidth = self.frame.width
        var collectionViewWidth: CGFloat = 0
        if screenWidth >= 410 {
            collectionViewWidth = 400
        } else {
            collectionViewWidth = 350
        }
        posterView.snp.updateConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(collectionViewWidth)
            make.height.equalTo(collectionViewWidth * 1.5)
        }
        collectionView.snp.updateConstraints { make in
            make.edges.equalTo(posterView)
        }
        pauseView.snp.makeConstraints { make in
            make.edges.equalTo(posterView)
        }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionViewWidth / 50, height: collectionViewWidth / 50)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // MARK: Hierarchy
    override func configureHierarchy() {
        addSubviews([timerBackView, timeLimitBar, posterView, collectionView, answerTextField, quizCount, pauseButton, pauseView])
    }
    
    // MARK: snapKit Layout
    override func setConstraints() {
        timerBackView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(self.safeAreaLayoutGuide).offset(20)
            make.bottom.lessThanOrEqualTo(posterView.snp.top).offset(-10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(25)
        }
        
        timeLimitBar.snp.makeConstraints { make in
            make.edges.equalTo(timerBackView).inset(4)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerY.equalTo(timerBackView).offset(-2)
            make.size.equalTo(30)
        }
       
        posterView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(360)
            make.height.equalTo(540)
        }
        
        quizCount.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(2)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(posterView)
        }
        
        answerTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.bottom.lessThanOrEqualTo(self.keyboardLayoutGuide.snp.top).offset(-1)
            make.height.equalTo(40)
        }
        
    }
    
    // MARK: View
    override func configureView() {
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.contentVerticalAlignment = .fill
        pauseButton.contentHorizontalAlignment = .fill
        pauseButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        pauseButton.tintColor = .pointOrange
        pauseView.isHidden = true
        pauseView.backgroundColor = .black
        quizCount.textColor = .black
        quizCount.font = .pretendard(size: 16, weight: .regular)
        timerBackView.layer.cornerRadius = 8
        timerBackView.layer.borderColor = UIColor.pointOrange.cgColor
        timerBackView.layer.borderWidth = 2
        timeLimitBar.layer.cornerRadius = 8
        timeLimitBar.clipsToBounds = true
        timeLimitBar.progressTintColor = .pointOrange
        timeLimitBar.trackTintColor = .clear
        collectionView.backgroundColor = .clear
        answerTextField.placeholder = "SolvePosterView_TextFieldPlaceHolder".localized
        answerTextField.layer.cornerRadius = 12
        answerTextField.layer.borderWidth = 2
        answerTextField.layer.borderColor = UIColor.pointOrange.cgColor
        answerTextField.textAlignment = .center
        answerTextField.returnKeyType = .done
        answerTextField.backgroundColor = .white
    }
    
    // MARK: collectionView Layout
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }
    
}

// MARK: Public Func
extension SolvePosterAreaQuizView {
    
    func setUIWhenPaused(isPaused: Bool, isShowAnswer: Bool) {
        if isPaused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        if !isShowAnswer {
            pauseView.isHidden = !isPaused
        }
    }
    
    func setQuizCount(currentIndex: Int, totalIndex: Int) {
        let text = "\(currentIndex)/\(totalIndex) "
        quizCount.text = text
        let target = "\(currentIndex)"
        quizCount.asFontColor(targetStringList: [target], font: .pretendard(size: 26, weight: .semiBold), color: .pointOrange)
    }
    
    func updateTimeLimitBar(_ progress: Float) {
        timeLimitBar.setProgress(progress, animated: true)
    }
    
    func fetchPoster(detailURL: String?) {
        guard let detailUrl = detailURL else { return }
        let url = PosterURL.imageURL(detailURL: detailUrl).endpoint
        posterView.kf.setImage(with: url)
        posterView.contentMode = .scaleToFill
    }
    
    func clearTextField() {
        answerTextField.text = ""
    }
    
    func setTextFieldAndButtonEnable(isEnabled: Bool) {
        answerTextField.isEnabled = isEnabled
    }
}
