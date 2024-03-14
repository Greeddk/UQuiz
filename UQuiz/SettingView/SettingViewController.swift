//
//  SettingViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class SettingViewController: BaseViewController {

    enum Section: CaseIterable {
        case first
    }
    
    let profileViewModel = ProfileManagerViewModel()
    let mainView = SettingView()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewModel.inputLoadProfileImageTrigger.value = ()
        configureDataSource()
        updateSnapshot()
    }
    // 이미지나 닉네임이 변경되었을 시, 샐이 리로드 되게하기
    
    override func configureViewController() {
        mainView.collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileSettingCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            if self.profileViewModel.outputUserProfileImage.value == nil {
                cell.roundProfileImage.image = UIImage(systemName: "person")
            } else {
                cell.roundProfileImage.image = self.profileViewModel.outputUserProfileImage.value
            }
            self.profileViewModel.outputNickname.bind { value in
                cell.nicknameLabel.text = value
            }
            cell.changeNicknameButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
            cell.changeNicknameButton.addTarget(self, action: #selector(self.changeNicknameButtonClicked), for: .touchUpInside)
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .lightGray
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
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
        let vc = SetProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SettingViewController: UICollectionViewDelegate{
  
    
}
