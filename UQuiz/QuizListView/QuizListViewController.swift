//
//  QuizListViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class QuizListViewController: BaseViewController {
    
    let mainView = QuizListView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(QuizCardCollectionViewCell.self, forCellWithReuseIdentifier: QuizCardCollectionViewCell.identifier)
        mainView.collectionView.isPagingEnabled = true
    }
    
    private func setNavigationBar() {
        navigationItem.title = "MainView"
    }


}

extension QuizListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCardCollectionViewCell.identifier, for: indexPath) as! QuizCardCollectionViewCell
        cell.title.text = "\(indexPath.item)"
        return cell
    }
    
}
