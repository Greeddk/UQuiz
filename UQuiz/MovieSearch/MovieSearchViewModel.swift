//
//  MoviewSearchViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

final class MovieSearchViewModel {
    
    let apiManager = TMDBAPIManager.shared
    
    var inputAPIRequest: Observable<String?> = Observable(nil)
    var inputButtonClickedTrigger: Observable<Movie?> = Observable(nil)
    var outputRequestList: Observable<[Movie]> = Observable([])
    var outputAddedToPackageList: Observable<Set<Movie>> = Observable([])
    
    init() {
        inputAPIRequest.bind { value in
            self.callRequest(query: value)
        }
        inputButtonClickedTrigger.bind { value in
            guard let value = value else { return }
            if self.outputAddedToPackageList.value.contains(value) {
                self.outputAddedToPackageList.value.remove(value)
            } else {
                self.outputAddedToPackageList.value.insert(value)
            }
            print("outputaddedList",self.outputAddedToPackageList.value)
        }
    }
    
    private func callRequest(query: String?) {
        guard let query = query else { return }
        apiManager.requestMovieInfo(type: SearchMovie.self, query: query) { value in
            let tmpList = value.results.filter { $0.poster != nil }
            self.outputRequestList.value = tmpList
        }
    }
    
}
