//
//  MakePosterAreaQuizViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class MakePosterAreaQuizViewController: BaseViewController {
    
    let mainView = MakePosterAreaQuizView()
    let viewModel = MakeMovieAreaQuizViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.alertTrigger.noInitBind { message in
            self.showAlert(title: "MakePosterQuizVC_AlertTitle".localized, message: message, okTitle: "ExtensionVC_AlertOK".localized) { }
        }
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mainView.collectionView.backgroundColor = .clear
        mainView.showPostersButton.addTarget(self, action: #selector(showPosterButtonClicked), for: .touchUpInside)
        mainView.nextMovieButton.addTarget(self, action: #selector(nextMovieButtonClicked), for: .touchUpInside)
        mainView.previousMovieButton.addTarget(self, action: #selector(previousMovieButtonClicked), for: .touchUpInside)
        fetchPoster()
        let resetButton = UIBarButtonItem(title: "MakePosterQuizVC_NavigationResetButton".localized, style: .plain, target: self, action: #selector(resetButtonClicked))
        navigationItem.rightBarButtonItem = resetButton
        setNavigationBackButton()
        navigationItem.title = String(format: "MakePosterQuizVC_NavigationTitle".localized, viewModel.outputNumberOfLevelSelectedArea.value)
    }
    
    private func fetchPoster() {
        let url = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].poster
        mainView.fetchPoster(detailURL: url)
    }
    
    private func fetchCollectionViewSelectedData() {
        resetCollectionView()
        let list =  viewModel.outputQuizPackage.value[viewModel.currentIndex.value].selectedArea
        let flattenedList = list.flatMap { $0 }
        for index in flattenedList {
            let cell = mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        }
    }
    
    @objc
    private func nextMovieButtonClicked() {
        let numberOfSelectArea = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].numberOfselectArea
        let levelValue = viewModel.outputNumberOfLevelSelectedArea.value
        if  numberOfSelectArea == levelValue {
            if viewModel.outputQuizPackage.value.count == viewModel.currentIndex.value + 1 {
                showTextFieldAlert(title: "MakePosterQuizVC_CompleteQuizAlertTitle".localized, message: "MakePosterQuizVC_CompleteQuizAlertMessage".localized, placeHolder: "MakePosterQuizVC_CompleteQuizAlertPlaceholder".localized) { title in
                    self.viewModel.inputQuizTitle.value = title
                    self.viewModel.inputSavePackageToRealmTrigger.value = ()
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = MainTabBarController()
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
            } else {
                viewModel.inputIndex.value = viewModel.currentIndex.value + 1
                fetchPoster()
                fetchCollectionViewSelectedData()
            }
        } else {
            showAlert(title: "MakePosterQuizVC_IncompleteQuizAlertTitle".localized, message: String(format: "MakePosterQuizVC_IncompleteQuizAlertMessage".localized, levelValue), okTitle: "ExtensionVC_AlertOK".localized) { }
        }
    }
    
    @objc
    private func previousMovieButtonClicked() {
        if viewModel.currentIndex.value != 0 {
            viewModel.inputIndex.value = viewModel.currentIndex.value - 1
            fetchPoster()
            fetchCollectionViewSelectedData()
        } else {
            showAlert(title: "MakePosterQuizVC_PreviousButtonClickedAlertTitle".localized, message: "MakePosterQuizVC_PreviousButtonClickedAlertMessage".localized, okTitle: "ExtensionVC_AlertOK".localized) { }
        }
    }
    
    @objc
    private func showPosterButtonClicked() {
        let vc = PosterListViewController()
        vc.viewModel.inputMovieID.value = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].id
        vc.closure = { [weak self] selectedPoster in
            guard let self = self else { return }
            self.viewModel.outputQuizPackage.value[self.viewModel.currentIndex.value].poster = selectedPoster
            self.fetchPoster()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc
    private func resetButtonClicked() {
        viewModel.outputQuizPackage.value[viewModel.currentIndex.value].numberOfselectArea = 0
        viewModel.inputResetSelectedAreaTrigger.value = ()
        fetchCollectionViewSelectedData()
    }
    
    private func resetCollectionView() {
        for index in 0...3749 {
            let cell = mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.backgroundColor = .black.withAlphaComponent(0.7)
        }
    }
    
}

extension MakePosterAreaQuizViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3750
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black.withAlphaComponent(0.7)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        viewModel.inputSelectedCellTrigger.value = index
        fetchCollectionViewSelectedData()
    }
    
}
