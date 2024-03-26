//
//  QuizListViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class QuizListViewController: BaseViewController {
    
    private let mainView = QuizListView()
    private let viewModel = QuizListViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputFetchPackageListTrigger.value = ()
        viewModel.outputPackageList.bind { [weak self] _ in
            self?.mainView.collectionView.reloadData()
            self?.mainView.collectionView.performBatchUpdates({
                self?.mainView.collectionView.collectionViewLayout.invalidateLayout()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(QuizCardCollectionViewCell.self, forCellWithReuseIdentifier: QuizCardCollectionViewCell.identifier)
        mainView.collectionView.isPagingEnabled = true
    }
    
}

extension QuizListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPackageList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCardCollectionViewCell.identifier, for: indexPath) as! QuizCardCollectionViewCell
        let list = Array(viewModel.outputPackageList.value)
        let package = list[indexPath.item]
        viewModel.inputIndex.value = indexPath.item
        cell.setUI(package)
        viewModel.outputProfileImage.bind { image in
            cell.setProfile(profileImage: image)
        }
        cell.setIndexLabel(index: "\(indexPath.item + 1) / \(viewModel.outputPackageList.value.count)")
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        cell.playButton.tag = indexPath.item
        cell.playButton.addTarget(self, action: #selector(playButtonTapped(sender:)), for: .touchUpInside)
        cell.shareButton.tag = indexPath.item
        cell.shareButton.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
        cell.shareButton.isHidden = true
        return cell
    }
    
}

extension QuizListViewController {
    
    @objc private func shareButtonTapped(sender: UIButton) {
//        do {
//            let transferPackage = viewModel.outputPackageList.value[sender.tag]
//            let encoder = JSONEncoder()
//            let jsonData = try encoder.encode(transferPackage)
//            
//            // 파일을 생성하고 해당 파일의 URL을 얻습니다.
//            //            let fileURL = try saveDataToFile(data: jsonData, fileName: "\(transferPackage.id)")
//            
//            // UIActivityViewController를 사용하여 파일을 공유합니다.
//            let activityViewController = UIActivityViewController(activityItems: [jsonData], applicationActivities: nil)
//            
//            // 제외할 액티비티 타입을 설정합니다.
//            activityViewController.excludedActivityTypes = [
//                .postToTencentWeibo, .addToReadingList, .assignToContact, .mail,
//                .markupAsPDF, .openInIBooks, .postToVimeo, .postToFlickr,
//                .saveToCameraRoll, .sharePlay, .print
//            ]
//            
//            // 공유 액티비티가 완료되었을 때 호출되는 핸들러를 정의합니다.
//            activityViewController.completionWithItemsHandler = { type, completed, items, error in
//                if completed {
//                    print("COMPLETED: ", items)
//                } else {
//                    print("FAILED: ", error?.localizedDescription)
//                }
//            }
//            
//            self.present(activityViewController, animated: true, completion: nil)
//            
//        } catch {
//            print("Error encoding quiz package: \(error)")
//        }
    }
    
    @objc private func deleteButtonTapped(sender: UIButton) {
        viewModel.inputDeletePackageTrigger.value = sender.tag
    }
    
    @objc private func playButtonTapped(sender: UIButton) {
        let vc = SolvePosterAreaQuizViewController()
        let list = Array(viewModel.outputPackageList.value[sender.tag].quizs)
        vc.viewModel.outputQuizList.value = list
        vc.viewModel.inputLevel.value = viewModel.outputPackageList.value[sender.tag].level
        vc.info = viewModel.outputPackageList.value[sender.tag].title
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

