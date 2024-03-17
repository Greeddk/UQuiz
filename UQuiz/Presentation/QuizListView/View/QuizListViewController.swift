//
//  QuizListViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class QuizListViewController: BaseViewController {
    
    private let mainView = QuizListView()
    private let viewModel = QuizListViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        viewModel.inputFetchPackageListTrigger.value = ()
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(QuizCardCollectionViewCell.self, forCellWithReuseIdentifier: QuizCardCollectionViewCell.identifier)
        mainView.collectionView.isPagingEnabled = true
    }
    
    private func setNavigationBar() {
        navigationItem.title = "MainView"
    }

}

extension QuizListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPackageList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCardCollectionViewCell.identifier, for: indexPath) as! QuizCardCollectionViewCell
        let package = viewModel.outputPackageList.value[indexPath.item]
        cell.setUI(package)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SolvePosterAreaQuizViewController()
        let list = Array(viewModel.outputPackageList.value[indexPath.item].quizs)
        vc.viewModel.outputQuizList.value = list
        vc.info = viewModel.outputPackageList.value[indexPath.item].title
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}


