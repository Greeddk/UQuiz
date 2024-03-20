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
        viewModel.outputAddedToPackage.bind { _ in
            self.setNavigationBar()
        }
    }

    override func configureViewController() {
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(MovieInfoCollectionViewCell.self, forCellWithReuseIdentifier: MovieInfoCollectionViewCell.identifier)
    }
    
    private func setNavigationBar() {
        navigationItem.title = String(format: "MovieSearchVC_NavigationTitle".localized, viewModel.outputAddedToPackage.value.count)
        let makeQuizPackageButton = UIBarButtonItem(title: "MovieSearchVC_barButtonTitle".localized, style: .plain, target: self, action: #selector(makeQuizPackageButtonClicked))
        if viewModel.outputAddedToPackage.value.count != 0 {
            makeQuizPackageButton.isEnabled = true
        } else {
            makeQuizPackageButton.isEnabled = false
        }
        
        navigationItem.rightBarButtonItem = makeQuizPackageButton
    }
    
    @objc
    private func makeQuizPackageButtonClicked() {
        let vc = MakePosterAreaQuizViewController()
        let list = Array(viewModel.outputAddedToPackage.value)
        vc.viewModel.inputQuizPackage.value = list
        vc.hidesBottomBarWhenPushed = true
        
        let alert = UIAlertController(title: "난이도 선택", message: "만들고 싶은 난이도를 선택해주세요!", preferredStyle: .alert)
        let beginner = UIAlertAction(title: "초보", style: .default) { _ in
            vc.viewModel.inputLevel.value = Level.beginner
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let intermediate = UIAlertAction(title: "중수", style: .default) { _ in
            vc.viewModel.inputLevel.value = Level.intermediate
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let expert = UIAlertAction(title: "고수", style: .default) { _ in
            vc.viewModel.inputLevel.value = Level.expert
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(beginner)
        alert.addAction(intermediate)
        alert.addAction(expert)
        present(alert, animated: true)
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
        let boolValue = viewModel.outputAddedToPackage.value.contains(item)
        cell.addToPackageImage.tintColor = boolValue ? .green : .systemGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        viewModel.inputButtonClickedTrigger.value = viewModel.outputRequestList.value[indexPath.item]
        collectionView.reloadItems(at: [indexPath])
    }
    
}
