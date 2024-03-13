//
//  PosterListViewController.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import UIKit
import Kingfisher

final class PosterListViewController: BaseViewController {
    
    let mainView = PosterListView()
    let viewModel = PosterListViewModel()
    var closure: ((String) -> Void)?
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputPosterList.bind { _ in
            self.mainView.collectionView.reloadData()
        }
    }
    
    override func configureViewController() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MovieInfoCollectionViewCell.self, forCellWithReuseIdentifier: MovieInfoCollectionViewCell.identifier)
    }

}

extension PosterListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPosterList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCollectionViewCell.identifier, for: indexPath) as! MovieInfoCollectionViewCell
        let url = PosterURL.imageURL(detailURL: viewModel.outputPosterList.value[indexPath.item].poster).endpoint
        cell.posterImage.kf.setImage(with: url)
        cell.addToPackageImage.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //값 전달
        closure?(viewModel.outputPosterList.value[indexPath.item].poster)
        dismiss(animated: true)
    }
    
}
