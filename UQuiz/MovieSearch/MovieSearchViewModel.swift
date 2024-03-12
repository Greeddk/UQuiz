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
    var outputAddedToPackage: Observable<Set<Movie>> = Observable([])
    
    init() {
        inputAPIRequest.bind { value in
            self.callRequest(query: value)
        }
        inputButtonClickedTrigger.bind { value in
            guard let value = value else { return }
            if self.outputAddedToPackage.value.contains(value) {
                self.outputAddedToPackage.value.remove(value)
            } else {
                self.outputAddedToPackage.value.insert(value)
            }
            print("outputaddedList",self.outputAddedToPackage.value)
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
