//
//  QuizListViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import Foundation
import UIKit

final class QuizListViewModel {
    
    private let repository = PosterQuizPackageRepository()
    private let fileManager = ImageFileManager()
    
    var inputFetchPackageListTrigger: Observable<Void?> = Observable(nil)
    var inputIndex: Observable<Int> = Observable(0)
    var inputDeletePackageTrigger: Observable<Int> = Observable(0)
    
    var outputPackageList: Observable<[RealmPosterQuizPackage]> = Observable([])
    var outputProfileImage: Observable<UIImage?> = Observable(nil)
    var outputReloadViewTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputFetchPackageListTrigger.noInitBind { _ in
            self.fetchList()
        }
        inputIndex.noInitBind { [weak self] value in
            self?.fetchProfileImage(index: value)
        }
        inputDeletePackageTrigger.noInitBind { value in
            self.deleteQuizPackage(index: value)
        }
    }
    
    private func fetchList() {
        outputPackageList.value = repository.fetchPackages()
    }
    
    private func fetchProfileImage(index: Int) {
        if outputPackageList.value.count > 0 {
            guard let filename = outputPackageList.value[inputIndex.value].makerInfo?.profile else { return }
            outputProfileImage.value = fileManager.loadImageFromDocument(filename: filename)
        }
    }
    
    private func deleteQuizPackage(index: Int) {
        let package = outputPackageList.value[index]
        outputPackageList.value.remove(at: index)
        repository.deletePackage(package: package)
    }
    
}
