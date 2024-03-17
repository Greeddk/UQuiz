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
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mainView.submitButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
        let detailURL = viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].poster
        mainView.fetchPoster(detailURL: detailURL)
    }
    
    @objc
    private func submitButtonClicked() {
        
    }

}

extension SolvePosterAreaQuizViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3750
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let list = viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].selectedArea
        // TODO: 보이는 부분 안보이는 부분 설정
        return cell
    }
    
}
