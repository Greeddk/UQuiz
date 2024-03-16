//
//  QuizListViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import Foundation

final class QuizListViewModel {
    
    private let repository = PosterQuizPackageRepository()
    
    var inputFetchPackageListTrigger: Observable<Void?> = Observable(nil)
    
    var outputPackageList: Observable<[RealmPosterQuizPackage]> = Observable([])
    
    init() {
        inputFetchPackageListTrigger.bind { _ in
            self.fetchList()
        }
    }
    
    private func fetchList() {
        outputPackageList.value = repository.fetchPackages()
    }
    
    
}
