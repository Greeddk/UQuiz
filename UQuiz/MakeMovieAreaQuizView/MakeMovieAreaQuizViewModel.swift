//
//  MakeMovieAreaQuizViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import Foundation

final class MakeMovieAreaQuizViewModel {
    
    var inputQuizPackage: Observable<[Movie]> = Observable([])
    var inputIndex: Observable<Int> = Observable(0)
    var inputSelectedCellTrigger: Observable<Int> = Observable(0)
    var inputResetSelectedAreaTrigger: Observable<Void?> = Observable(nil)
    
    var outputQuizPackage: Observable<[Quiz]> = Observable([])
    var currentIndex: Observable<Int> = Observable(0)
    var outputSelectedCellList: Observable<[Int]> = Observable([])
    var alertTrigger: Observable<String> = Observable("")
    
    let cellArea: [Int] = [-74, -73, -72, -71, -70, -38, -37, -36, -35, -34, -2, -1, 0, 1, 2, 34, 35, 36, 37, 38, 70, 71, 72, 73, 74]
    
    init() {
        inputQuizPackage.bind { value in
            self.outputQuizPackage.value = self.changeMovieToQuiz(items: value)
        }
        inputIndex.bind { value in
            self.currentIndex.value = value
        }
        inputResetSelectedAreaTrigger.noInitBind { _ in
            self.outputQuizPackage.value[self.currentIndex.value].selectedArea = self.resetSelectedList()
        }
        inputSelectedCellTrigger.noInitBind { index in
            self.selectArea(index: index)
        }
    }
    
    private func validateArea(index: Int) -> Bool {
        
        for value in cellArea {
            if outputQuizPackage.value[currentIndex.value].selectedArea[index + value] == 1 {
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
        
        if index % 36 == 0 || index % 36 == 1 { //왼쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else if (0...71).contains(index) { //위쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else if index % 36 == 34 || index % 36 == 35 { //오른쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else if (1871...1943).contains(index) { //아래쪽
            print(index)
            alertTrigger.value = "조금 더 안쪽 부분을 선택해주세요!"
        } else {
            if validateArea(index: index) {
                for value in cellArea {
                    outputQuizPackage.value[currentIndex.value].selectedArea[index + value] = 1
                }
                outputQuizPackage.value[currentIndex.value].numberOfselectArea += 1
            }
        }
    }
    
    private func changeMovieToQuiz(items: [Movie]) -> [Quiz] {
        var outputList: [Quiz] = []
        items.forEach { movie in
            outputList.append(Quiz(item: movie))
        }
        return outputList
    }
    
    private func resetSelectedList() -> [Int] {
        var outputList: [Int] = []
        for _ in 0...1943 {
            outputList.append(0)
        }
        return outputList
    }
    
}
