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
        inputAPIRequest.bind { [weak self] value in
            self?.callRequest(query: value)
        }
        inputButtonClickedTrigger.bind { [weak self] value in
            guard let self = self, let value = value else { return }
            if self.outputAddedToPackage.value.contains(value) {
                self.outputAddedToPackage.value.remove(value)
            } else {
                self.outputAddedToPackage.value.insert(value)
            }
        }
    }
    
    private func callRequest(query: String?) {
        guard let query = query else { return }
        apiManager.requestMovieInfo(type: SearchMovie.self, query: query) { [weak self] value in
            guard let self = self else { return }
            let tmpList = value.results.filter { $0.poster != nil }
            self.outputRequestList.value = tmpList
        }
    }
    
}
