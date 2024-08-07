//
//  ViewController.swift
//  UQuiz
//
//  Created by Greed on 3/7/24.
//

import UIKit
import Kingfisher

final class MovieSearchViewController: BaseViewController {
    
    let viewModel = MovieSearchViewModel()
    let mainView = MovieSearchView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenViewIsTapped()
        viewModel.outputRequestList.bind { [weak self] _ in
            self?.mainView.collectionView.reloadData()
        }
        viewModel.outputAddedToPackage.bind { [weak self] _ in
            self?.setNavigationBar()
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
        
        let alert = UIAlertController(title: "MovieSearchVC_AlertTitle".localized, message: "MovieSearchVC_AlertMessage".localized, preferredStyle: .alert)
        let beginner = UIAlertAction(title: "MovieSearchVC_AlertBeginner".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            vc.viewModel.inputLevel.value = Level.beginner
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let intermediate = UIAlertAction(title: "MovieSearchVC_AlertImtermediate".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            vc.viewModel.inputLevel.value = Level.intermediate
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let expert = UIAlertAction(title: "MovieSearchVC_AlertExpert".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            vc.viewModel.inputLevel.value = Level.expert
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancel = UIAlertAction(title: "ExtensionVC_AlertCancel".localized, style: .destructive)
        alert.addAction(beginner)
        alert.addAction(intermediate)
        alert.addAction(expert)
        alert.addAction(cancel)
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
        viewModel.inputButtonClickedTrigger.value = viewModel.outputRequestList.value[indexPath.item]
        collectionView.reloadItems(at: [indexPath])
    }
    
}
