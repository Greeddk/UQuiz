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
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var outputPosterList: Observable<[Poster]> = Observable([])
    
    init() {
        inputMovieID.bind { _ in
            self.fetchPosters()
        }
    }
    
    private func fetchPosters() {
        apiManager.requestPosters(id: inputMovieID.value) { [weak self] value in
            guard let self = self else { return }
            self.outputPosterList.value = value.posters
            print("poster fetching~~~")
        }
    }
}
