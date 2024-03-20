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
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(QuizCardCollectionViewCell.self, forCellWithReuseIdentifier: QuizCardCollectionViewCell.identifier)
        mainView.collectionView.isPagingEnabled = true
        navigationController?.isNavigationBarHidden = true
    }

}

extension QuizListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPackageList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCardCollectionViewCell.identifier, for: indexPath) as! QuizCardCollectionViewCell
        let list = Array(viewModel.outputPackageList.value.reversed())
        let package = list[indexPath.item]
        viewModel.inputIndex.value = indexPath.item
        viewModel.outputProfileImage.bind { image in
            cell.setUI(package, profileImage: (image ?? UIImage(systemName: "person"))!)
        }
        cell.setIndexLabel(index: "\(indexPath.item + 1) / \(viewModel.outputPackageList.value.count)")
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    // TODO: Touch가 안됨...
    @objc private func deleteButtonTapped(sender: UIButton) {
        print(#function)
        viewModel.inputDeletePackageTrigger.value = sender.tag
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SolvePosterAreaQuizViewController()
        let list = Array(viewModel.outputPackageList.value.reversed()[indexPath.item].quizs)
        vc.viewModel.outputQuizList.value = list
        vc.viewModel.inputLevel.value = viewModel.outputPackageList.value.reversed()[indexPath.item].level
        vc.info = viewModel.outputPackageList.value[indexPath.item].title
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}


