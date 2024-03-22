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
        viewModel.inputFetchPackageListTrigger.value = ()
        viewModel.outputPackageList.bind { [weak self] _ in
            self?.mainView.collectionView.reloadData()
            self?.mainView.collectionView.performBatchUpdates({
                self?.mainView.collectionView.collectionViewLayout.invalidateLayout()
                  })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(QuizCardCollectionViewCell.self, forCellWithReuseIdentifier: QuizCardCollectionViewCell.identifier)
        mainView.collectionView.isPagingEnabled = true
    }
    
}

extension QuizListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPackageList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCardCollectionViewCell.identifier, for: indexPath) as! QuizCardCollectionViewCell
        let list = Array(viewModel.outputPackageList.value)
        let package = list[indexPath.item]
        viewModel.inputIndex.value = indexPath.item
        cell.setUI(package)
        viewModel.outputProfileImage.bind { image in
            cell.setProfile(profileImage: image)
        }
        cell.setIndexLabel(index: "\(indexPath.item + 1) / \(viewModel.outputPackageList.value.count)")
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        cell.playButton.tag = indexPath.item
        cell.playButton.addTarget(self, action: #selector(playButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }

}

extension QuizListViewController {
    
    @objc private func deleteButtonTapped(sender: UIButton) {
        viewModel.inputDeletePackageTrigger.value = sender.tag
    }
    
    @objc private func playButtonTapped(sender: UIButton) {
        let vc = SolvePosterAreaQuizViewController()
        let list = Array(viewModel.outputPackageList.value[sender.tag].quizs)
        vc.viewModel.outputQuizList.value = list
        vc.viewModel.inputLevel.value = viewModel.outputPackageList.value[sender.tag].level
        vc.info = viewModel.outputPackageList.value[sender.tag].title
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
