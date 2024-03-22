//
//  QuizResultViewController.swift
//  UQuiz
//
//  Created by Greed on 3/17/24.
//

import UIKit

final class QuizResultViewController: BaseViewController {
    
    private let mainView = QuizResultView()
    let viewModel = QuizResultViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureViewController() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MovieCardCollectionViewCell.self, forCellWithReuseIdentifier: MovieCardCollectionViewCell.identifier)
        mainView.setUI(score: viewModel.outputCorretRate.value)
        hideBackButton()
        mainView.goHomeButton.addTarget(self, action: #selector(goHomeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func goHomeButtonClicked() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension QuizResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.inputData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCollectionViewCell.identifier, for: indexPath) as! MovieCardCollectionViewCell
        let movieData = viewModel.inputData.value[indexPath.item]
        cell.configureCell(movie: movieData)
        return cell
    }
    
}
