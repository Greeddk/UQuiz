//
//  PosterListViewController.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import UIKit

final class PosterListViewController: BaseViewController {
    
    let mainView = PosterListView()
    let viewModel = PosterListViewModel()
    var closure: ((String) -> Void)?
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputPosterList.bind { [weak self] _ in
            guard let self = self else { return }
            self.mainView.collectionView.reloadData()
        }
    }
    
    override func configureViewController() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MovieInfoCollectionViewCell.self, forCellWithReuseIdentifier: MovieInfoCollectionViewCell.identifier)
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc
    private func dismissButtonClicked() {
        dismiss(animated: true)
    }

}

extension PosterListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPosterList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCollectionViewCell.identifier, for: indexPath) as! MovieInfoCollectionViewCell
        cell.fetchThumbnails(item: viewModel.outputPosterList.value[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //값 전달
        closure?(viewModel.outputPosterList.value[indexPath.item].poster)
        dismiss(animated: true)
    }
    
}
