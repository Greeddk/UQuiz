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
    @Persisted var makerInfo: RealmMakerInfo
    
    init(title: String, quizs: List<RealmPosterQuiz>, maker: RealmMakerInfo) {
        self.init()
        self.title = title
        self.quizs = quizs
        self.makerInfo = maker
    }
    
}

final class RealmPosterQuiz: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var genre: List<Int>
    @Persisted var poster: String
    @Persisted var title: String
    @Persisted var selectedArea: List<Int>
    @Persisted var numberOfselectArea: Int
    @Persisted var isCorrect: Bool
    
    init(id: Int, genre: List<Int>, poster: String, title: String, selectedArea: List<Int>, numberOfselectArea: Int) {
        self.init()
        self.id = id
        self.genre = genre
        self.poster = poster
        self.title = title
        self.selectedArea = selectedArea
        self.numberOfselectArea = numberOfselectArea
        self.isCorrect = false
    }

}

final class RealmMakerInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var profile: String
    
    init(nickname: String, profile: String) {
        self.init()
        self.nickname = nickname
        self.profile = profile
    }
}