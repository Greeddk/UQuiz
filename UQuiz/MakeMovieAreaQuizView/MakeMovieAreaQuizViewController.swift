//
//  MakeMovieAreaQuizViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class MakeMovieAreaQuizViewController: BaseViewController {
    
    let mainView = MakeMovieAreaQuizView()
    let viewModel = MakeMovieAreaQuizViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.alertTrigger.noInitBind { message in
            self.showAlert(title: "주의!", message: message, okTitle: "확인")
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
        let resetButton = UIBarButtonItem(title: "reset", style: .plain, target: self, action: #selector(resetButtonClicked))
        navigationItem.rightBarButtonItem = resetButton
    }
    
    private func fetchPoster() {
        let url = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].poster
        mainView.fetchPoster(detailURL: url)
    }
    
    private func fetchCollectionViewSelectedData() {
        let list =  viewModel.outputQuizPackage.value[viewModel.currentIndex.value].selectedArea
        for index in 0...list.count - 1 {
            let cell = mainView.collectionView.cellForItem(at: NSIndexPath(item: index, section: 0) as IndexPath)
            if list[index] == 0 {
                cell?.backgroundColor = .black.withAlphaComponent(0.7)
            } else {
                cell?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
        }
    }
    
    @objc
    private func nextMovieButtonClicked() {
        let numberOfSelectArea = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].numberOfselectArea
        if  numberOfSelectArea == 5 {
            if viewModel.outputQuizPackage.value.count == viewModel.currentIndex.value + 1 {
                //quiz 묶음 저장
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = MainTabBarController()
                sceneDelegate?.window?.makeKeyAndVisible()
            } else {
                viewModel.inputIndex.value = viewModel.currentIndex.value + 1
                fetchPoster()
                fetchCollectionViewSelectedData()
            }
        } else {
            showAlert(title: "더 선택해주세요!", message: "5곳의 영역을 선택해주세요", okTitle: "확인")
        }
    }
    
    @objc
    private func previousMovieButtonClicked() {
        if viewModel.currentIndex.value != 0 {
            viewModel.inputIndex.value = viewModel.currentIndex.value - 1
            fetchPoster()
            fetchCollectionViewSelectedData()
        } else {
            showAlert(title: "이전 영화가 없습니다", message: "영역 선택 혹은 다음으로 넘어가주세요!", okTitle: "확인")
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
    
}

extension MakeMovieAreaQuizViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1944
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

//private func animateButtonTouch(isDecrease: Bool, reset: Bool = false) {
//    let timing = CAMediaTimingFunction(name: reset ? .easeIn : .easeOut)
//    let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
//    
//    var newTransform = CATransform3DIdentity
//    newTransform.m34 = -0.004
//    newTransform = CATransform3DRotate(newTransform, (isDecrease ? -1 : 1) * .pi / 6, 0, 1, 0)
//    
//    CATransaction.begin()
//    if !reset {
//        CATransaction.setCompletionBlock { [weak self] in
//            self?.animateButtonTouch(isDecrease: isDecrease, reset: true)
//        }
//    }
//    CATransaction.setAnimationTimingFunction(timing)
//    animation.duration = 0.18
//    if reset {
//        animation.fromValue = newTransform
//        animation.toValue = CATransform3DIdentity
//    } else {
//        animation.fromValue = CATransform3DIdentity
//        animation.toValue = newTransform
//    }
//    container.layer.transform = (animation.toValue as? CATransform3D)!
//    container.layer.add(animation, forKey: nil)
//    CATransaction.commit()
//}
