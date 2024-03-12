//
//  MakeMovieAreaQuizViewController.swift
//  UQuiz
//
//  Created by Greed on 3/11/24.
//

import UIKit

final class MakeMovieAreaQuizViewController: BaseViewController {
    //TODO: 네비게이션 타이틀 영역에 버튼을 넣어 다음문제 이전 문제로 넘어갈 수 있게, 문제 만들기 버튼과 reset 버튼도 필요
    let mainView = MakeMovieAreaQuizView()
    let viewModel = MakeMovieAreaQuizViewModel()
    
    var selectedArea: [Int] = []
    var selectedCells = 0
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...1943 {
            selectedArea.append(0)
        }
        view.backgroundColor = .white

    }
    
    override func configureViewController() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mainView.collectionView.backgroundColor = .clear
        mainView.showPostersButton.addTarget(self, action: #selector(showPosterButtonClicked), for: .touchUpInside)
        let url = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].poster
        mainView.fetchPoster(detailURL: url)
    }
    
    @objc
    private func showPosterButtonClicked() {
        let vc = PosterListViewController()
        vc.viewModel.inputMovieID.value = viewModel.outputQuizPackage.value[viewModel.currentIndex.value].id
        present(vc, animated: true)
    }
    
    @objc
    private func nextButtonClicked() {
        
        for index in 0...1943 {
            let cell = mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            if cell?.backgroundColor == UIColor.white.withAlphaComponent(0.2) {
                selectedArea[index] = 1
            } else {
                selectedArea[index] = 0
            }
        }
        
//        let vc = QuizViewController()
//        vc.selectedArea = self.selectedArea
//        vc.movieImageURL = self.movieURL
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func resetButtonClicked() {
        selectedCells = 0
        for index in 0...1943 {
            selectedArea[index] = 0
            let cell = self.mainView.collectionView.cellForItem(at: NSIndexPath(item: index, section: 0) as IndexPath)
            cell?.backgroundColor = .black.withAlphaComponent(0.8)
        }
    }
    
}

extension MakeMovieAreaQuizViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1944
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.backgroundColor = .black.withAlphaComponent(0.7)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.item
        
        let selectedArea: [Int] = [-74, -73, -72, -71, -70, -38, -37, -36, -35, -34, -2, -1, 0, 1, 2, 34, 35, 36, 37, 38, 70, 71, 72, 73, 74]
        
        //선택된 영역 선택 안되게
        for value in selectedArea {
            let cell = collectionView.cellForItem(at: IndexPath(item: index + value, section: 0 ))
            if cell?.backgroundColor == UIColor.white.withAlphaComponent(0.2) {
                let alert = UIAlertController(title: "다른 곳을 선택해주세요", message: "같은 영역을 선택할 수 없습니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default)
                alert.addAction(ok)
                present(alert, animated: true)
                return
            }
        }
        
        //모서리 부분 처리 알고리즘
        if index % 36 == 0 || index % 36 == 1 { //왼쪽
            print(index)
            //            if (0...71).contains(index) && index % 36 == 0 {
            //                for value in selectedArea {
            //                    let cell = collectionView.cellForItem(at: IndexPath(item: index + value + 2, section: 0 ))
            //                    print(index)
            //                    self.selectedArea[index + value] = 1
            //                    cell?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            //                }
            //            }
        } else if (0...71).contains(index) { //위쪽
            print(index)
        } else if index % 36 == 34 || index % 36 == 35 { //오른쪽
            print(index)
        } else if (1871...1943).contains(index) { //아래쪽
            print(index)
        } else {
            if selectedCells >= 5 {
                
            } else {
                for value in selectedArea {
                    let cell = collectionView.cellForItem(at: IndexPath(item: index + value, section: 0 ))
                    cell?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                }
                selectedCells += 1
            }
        }
        
    }
    
}
