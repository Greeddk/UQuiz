//
//  PosterQuizPackage.swift
//  UQuiz
//
//  Created by Greed on 3/24/24.
//

import Foundation

struct PosterQuizPackage: Codable {
    let title: String
    let quizs: [PosterQuiz]
    let makerInfo: MakerInfo
    let level: Int
    let numberOfQuiz: Int
    
    init(realmPackage: RealmPosterQuizPackage) {
        self.title = realmPackage.title
        self.makerInfo = MakerInfo(realmMakerInfo: realmPackage.makerInfo!)
        self.level = realmPackage.level
        self.numberOfQuiz = realmPackage.numberOfQuiz
        
        // RealmList에서 Swift Array로 변환
        var quizs: [PosterQuiz] = []
        for realmQuiz in realmPackage.quizs {
            let quiz = PosterQuiz(id: realmQuiz.movieId,
                                  genre: Array(realmQuiz.genre),
                                  poster: realmQuiz.poster,
                                  title: realmQuiz.title,
                                  original_title: realmQuiz.original_title,
                                  selectedArea: realmQuiz.selectedArea.map { Array($0.area) },
                                  numberOfselectArea: realmQuiz.numberOfselectArea,
                                  overview: realmQuiz.overview,
                                  release_date: realmQuiz.release_date)
            quizs.append(quiz)
        }
        self.quizs = quizs
    }
}
