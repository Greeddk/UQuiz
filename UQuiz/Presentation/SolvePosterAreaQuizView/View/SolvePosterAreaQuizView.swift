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
    
    let timerBackView = UIView()
    let timeLimitBar = UIProgressView(progressViewStyle: .default)
    let posterView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let answerTextField = UITextField()
    let submitButton = UIButton()
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
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionViewWidth / 50, height: collectionViewWidth / 50)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // MARK: Hierarchy
    override func configureHierarchy() {
        addSubviews([timerBackView, timeLimitBar, posterView, collectionView, answerTextField, submitButton])
    }
    
    // MARK: snapKit Layout
    override func setConstraints() {
        timerBackView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(self.safeAreaLayoutGuide).offset(20)
            make.bottom.lessThanOrEqualTo(posterView.snp.top).offset(-10)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(25)
        }
        
        timeLimitBar.snp.makeConstraints { make in
            make.edges.equalTo(timerBackView).inset(4)
        }
       
        posterView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(360)
            make.height.equalTo(540)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(posterView)
        }
        
        answerTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(collectionView.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-70)
            make.height.equalTo(40)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(answerTextField)
            make.leading.equalTo(answerTextField.snp.trailing)
            make.size.equalTo(40)
        }
        
    }
    
    // MARK: View
    override func configureView() {
        timerBackView.layer.cornerRadius = 8
        timerBackView.layer.borderColor = UIColor.purple.cgColor
        timerBackView.layer.borderWidth = 1
        timeLimitBar.layer.cornerRadius = 8
        timeLimitBar.clipsToBounds = true
        timeLimitBar.progressTintColor = .systemBlue
        timeLimitBar.trackTintColor = .clear
        collectionView.backgroundColor = .clear
        submitButton.setTitle("입력", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        answerTextField.placeholder = "정답 입력"
        answerTextField.layer.cornerRadius = 12
        answerTextField.layer.borderWidth = 1
        answerTextField.layer.borderColor = UIColor.black.cgColor
        answerTextField.textAlignment = .center
    }
    
    // MARK: collectionView Layout
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }
    
}

// MARK: Public Func
extension SolvePosterAreaQuizView {
    
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
        submitButton.isEnabled = isEnabled
    }
}
