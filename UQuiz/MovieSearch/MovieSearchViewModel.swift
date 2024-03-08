//
//  MoviewSearchViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

class MovieSearchViewModel {
    
    let apiManager = TMDBAPIManager.shared
    
    var inputAPIRequest: Observable<String?> = Observable(nil)
    
    var outputList: Observable<SearchMovie> = Observable(SearchMovie(results: []))
    
    init() {
        inputAPIRequest.bind { value in
            self.callRequest(query: value)
        }
    }
    
    private func callRequest(query: String?) {
        guard let query = query else { return }
        apiManager.request(type: SearchMovie.self, api: .movieSearchURL(query: query)) { value in
            self.outputList.value = value
        }
    }
}
