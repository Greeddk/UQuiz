//
//  RealmPosterQuiz.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation
import RealmSwift

final class RealmPosterQuizPackage: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var quizs: List<RealmPosterQuiz>
    @Persisted var makerInfo: RealmMakerInfo?
    @Persisted var level: Int
    var numberOfQuiz: Int {
        self.quizs.count
    }
    
    convenience init(title: String, quizs: List<RealmPosterQuiz>, maker: RealmMakerInfo, level: Level.RawValue) {
        self.init()
        self.title = title
        self.quizs = quizs
        self.makerInfo = maker
        self.level = level
    }
    
}

final class RealmPosterQuiz: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var movieId: Int
    @Persisted var genre: List<Int>
    @Persisted var poster: String
    @Persisted var title: String
    @Persisted var original_title: String
    @Persisted var selectedArea: List<RealmSelectedArea>
    @Persisted var numberOfselectArea: Int
    @Persisted var isCorrect: Bool
    @Persisted var overview: String
    @Persisted var release_date: String
    
    convenience init(movieId: Int, genre: List<Int>, poster: String, title: String, original_title: String, selectedArea: List<RealmSelectedArea>, numberOfselectArea: Int, overview: String, release_date: String) {
        self.init()
        self.movieId = movieId
        self.genre = genre
        self.poster = poster
        self.title = title
        self.original_title = original_title
        self.selectedArea = selectedArea
        self.numberOfselectArea = numberOfselectArea
        self.isCorrect = false
        self.overview = overview
        self.release_date = release_date
    }

}

final class RealmSelectedArea: EmbeddedObject {
    @Persisted var area: List<Int>
}

final class RealmMakerInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var profile: String
    
    convenience init(nickname: String, profile: String) {
        self.init()
        self.nickname = nickname
        self.profile = profile
    }
}
