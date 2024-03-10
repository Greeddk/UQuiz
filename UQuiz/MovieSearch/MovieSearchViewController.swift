//
//  ViewController.swift
//  UQuiz
//
//  Created by Greed on 3/7/24.
//

import UIKit
import Kingfisher
import os

final class MovieSearchViewController: BaseViewController {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "error", category: "MovieSearchViewController")
    let viewModel = MovieSearchViewModel()
    let mainView = MovieSearchView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenViewIsTapped()
        viewModel.outputRequestList.bind { _ in
            self.mainView.collectionView.reloadData()
            self.logger.info("outputList \(self.viewModel.outputRequestList.value)")
        }
    }

    override func configureViewController() {
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MovieInfoCollectionViewCell.self, forCellWithReuseIdentifier: MovieInfoCollectionViewCell.identifier)
    }

}

extension MovieSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputAPIRequest.value = searchBar.text
        view.endEditing(true)
    }
    
}

extension MovieSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputRequestList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCollectionViewCell.identifier, for: indexPath) as! MovieInfoCollectionViewCell
        let item = viewModel.outputRequestList.value[indexPath.item]
        cell.configureCell(movieItem: item)
        cell.addToPackageButton.tag = indexPath.item
        cell.addToPackageButton.addTarget(self, action: #selector(addToPackageButtonClicked(sender:)), for: .touchUpInside)
        let boolValue = viewModel.outputAddedToPackageList.value.contains(item)
        cell.addToPackageButton.tintColor = boolValue ? .green : .systemGray
        return cell
    }
    
    @objc
    private func addToPackageButtonClicked(sender: UIButton!) {
        viewModel.inputButtonClickedTrigger.value = viewModel.outputRequestList.value[sender.tag]
        mainView.collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
    
}
