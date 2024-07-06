//
//  MakeMovieAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import Foundation

final class MakeMovieAreaQuizViewModel {
    
    private let quizRepository = PosterQuizPackageRepository()
    private let makerRepository = MakerInfoRepository()
    
    var inputQuizPackage: Observable<[Movie]> = Observable([])
    var inputIndex: Observable<Int> = Observable(0)
    var inputSelectedCellTrigger: Observable<Int> = Observable(0)
    var inputResetSelectedAreaTrigger: Observable<Void?> = Observable(nil)
    var inputSavePackageToRealmTrigger: Observable<Void?> = Observable(nil)
    var inputQuizTitle: Observable<String> = Observable("영화 맞추기")
    var inputLevel: Observable<Level> = Observable(.beginner)
    
    var outputQuizPackage: Observable<[PosterQuiz]> = Observable([])
    var currentIndex: Observable<Int> = Observable(0)
    var outputSelectedCellList: Observable<[Int]> = Observable([])
    var outputNumberOfLevelSelectedArea: Observable<Int> = Observable(3)
    var alertTrigger: Observable<String> = Observable("")
    
    private let cellArea: [Int] = [-102, -101, -100, -99, -98, -52, -51, -50, -49, -48, -2, -1, 0, 1, 2, 48, 49, 50, 51, 52, 98, 99, 100, 101, 102]
    
    init() {
        transform()
    }
    
    private func transform() {
        inputQuizPackage.bind { value in
            self.outputQuizPackage.value = self.changeMovieToQuiz(items: value)
        }
        inputIndex.bind { value in
            self.currentIndex.value = value
        }
        inputResetSelectedAreaTrigger.noInitBind { _ in
            self.outputQuizPackage.value[self.currentIndex.value].selectedArea = []
        }
        inputSelectedCellTrigger.noInitBind { index in
            self.selectArea(index: index)
        }
        inputSavePackageToRealmTrigger.noInitBind { _ in
            self.saveQuiz()
        }
        inputLevel.bind { level in
            self.adjustNunberOfSelectedArea(level)
        }
    }
    
    private func adjustNunberOfSelectedArea(_ level: Level) {
        switch self.inputLevel.value {
        case .beginner:
            outputNumberOfLevelSelectedArea.value = 5
        case .intermediate:
            outputNumberOfLevelSelectedArea.value = 4
        case .expert:
            outputNumberOfLevelSelectedArea.value = 3
        }
    }
    
    private func saveQuiz() {
        let maker = makerRepository.fetchMakerInfo()
        quizRepository.createPackage(package: outputQuizPackage.value, title: inputQuizTitle.value, makerInfo: maker, level: inputLevel.value)
    }
    
    private func validateArea(index: Int) -> Bool {
        
        for value in cellArea {
            let flattedList = outputQuizPackage.value[currentIndex.value].selectedArea.flatMap { $0 }
            if flattedList.contains(index + value) {
                alertTrigger.value = "MakePosterQuizVM_InvalidateAreaMessage".localized
                return false
            }
        }
        return true
    }
    
    private func selectArea(index: Int) {
        
        let quizItem = outputQuizPackage.value[currentIndex.value]
        let numberOfArea = outputNumberOfLevelSelectedArea.value
        if quizItem.numberOfselectArea >= numberOfArea {
            alertTrigger.value = String(format: "MakePosterQuizVM_SelectAreaMessage".localized, numberOfArea)
            return
        }
        
        //TODO: 분기 나눠서 처리하기
        if index % 50 == 0 || index % 50 == 1 { //왼쪽
            alertTrigger.value = "MakePosterQuizVM_SelectInsideAreaMessage".localized
        } else if (0...99).contains(index) { //위쪽
            alertTrigger.value = "MakePosterQuizVM_SelectInsideAreaMessage".localized
        } else if index % 50 == 48 || index % 50 == 49 { //오른쪽
            alertTrigger.value = "MakePosterQuizVM_SelectInsideAreaMessage".localized
        } else if (3651...3749).contains(index) { //아래쪽
            alertTrigger.value = "MakePosterQuizVM_SelectInsideAreaMessage".localized
        } else {
            if validateArea(index: index) {
                var tmp: [Int] = []
                for value in cellArea {
                    tmp.append(index + value)
                }
                outputQuizPackage.value[currentIndex.value].selectedArea.append(tmp)
                outputQuizPackage.value[currentIndex.value].numberOfselectArea += 1
            }
        }
    }
    
    private func changeMovieToQuiz(items: [Movie]) -> [PosterQuiz] {
        var outputList: [PosterQuiz] = []
        items.forEach { movie in
            outputList.append(PosterQuiz(item: movie))
        }
        return outputList
    }
    
}
