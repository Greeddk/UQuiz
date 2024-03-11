//
//  SettingViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    enum Section {
        case first
    }
    
    let mainView = SettingView()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        updateSnapshot()
    }
    
    override func configureViewController() {
        mainView.collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<ProfileSettingCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            cell.roundProfileImage.image = UIImage(systemName: "person")
            cell.nicknameLabel.text = "메이커 이름"
            cell.changeNicknameButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
            cell.changeNicknameButton.addTarget(self, action: #selector(self.changeNicknameButtonClicked), for: .touchUpInside)
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .lightGray
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.first])
        snapshot.appendItems([0], toSection: .first)
        dataSource.apply(snapshot)
    }
    
    @objc
    private func changeNicknameButtonClicked() {
        let vc = SetNicknameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SettingViewController: UICollectionViewDelegate{
  
    
}
