//
//  PosterListViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import Foundation

final class PosterListViewModel {
    
    private let apiManager = TMDBAPIManager.shared
    
    var inputMovieID: Observable<Int> = Observable(0)
    var inputItemSelectTrigger: Observable<Int> = Observable(0)
    
    var outputPosterList: Observable<[Poster]> = Observable([])
    
    init() {
        inputMovieID.bind { _ in
            self.fetchPosters()
        }
    }
    
    private func fetchPosters() {
        apiManager.requestPosters(id: inputMovieID.value) { value in
            let targetPoster = value.filter({ $0.country == "ko" || $0.country == "en" }).sorted(by: { $0.country > $1.country })
            let restPoster = value.filter({ $0.country != "ko" && $0.country != "en"}).sorted(by: { $0.country > $1.country })
            let sortedList = targetPoster + restPoster
            self.outputPosterList.value = sortedList
        }
    }
}
