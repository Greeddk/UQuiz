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
    
    var outputQuizPackage: Observable<[PosterQuiz]> = Observable([])
    var currentIndex: Observable<Int> = Observable(0)
    var outputSelectedCellList: Observable<[Int]> = Observable([])
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
    }
    
    private func saveQuiz() {
        let maker = makerRepository.fetchMakerInfo()
        quizRepository.createPackage(package: outputQuizPackage.value, title: inputQuizTitle.value, makerInfo: maker)
    }
    
    private func validateArea(index: Int) -> Bool {
        
        for value in cellArea {
            let flattedList = outputQuizPackage.value[currentIndex.value].selectedArea.flatMap { $0 }
            if flattedList.contains(index + value) {
                alertTrigger.value = "같은 영역을 선택할 수 없습니다!"
                return false
            }
        }
        return true
    }
    
    private func selectArea(index: Int) {
        let quizItem = outputQuizPackage.value[currentIndex.value]
        
        if quizItem.numberOfselectArea >= 5 {
            alertTrigger.value = "영역 선택은 최대 5개까지 가능합니다!"
            return
        }
        
        if index % 50 == 0 || index % 50 == 1 { //왼쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else if (0...99).contains(index) { //위쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else if index % 50 == 48 || index % 50 == 49 { //오른쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else if (3651...3749).contains(index) { //아래쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
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
