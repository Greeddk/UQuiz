//
//  RealmPosterQuiz.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation
import RealmSwift

final class RealmPosterQuizPackage: Object, Codable {
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

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(quizs, forKey: .quizs)
        try container.encode(makerInfo, forKey: .makerInfo)
        try container.encode(level, forKey: .level)
    }
}

final class RealmPosterQuiz: Object, Codable  {
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
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(movieId, forKey: .movieId)
        try container.encode(genre, forKey: .genre)
        try container.encode(poster, forKey: .poster)
        try container.encode(title, forKey: .title)
        try container.encode(original_title, forKey: .original_title)
        try container.encode(selectedArea, forKey: .selectedArea)
        try container.encode(numberOfselectArea, forKey: .numberOfselectArea)
        try container.encode(isCorrect, forKey: .isCorrect)
        try container.encode(overview, forKey: .overview)
        try container.encode(release_date, forKey: .release_date)
    }

}

final class RealmSelectedArea: EmbeddedObject, Codable  {
    @Persisted var area: List<Int>

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(area, forKey: .area)
    }
}

final class RealmMakerInfo: Object, Codable  {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var profile: String
    
    convenience init(nickname: String, profile: String) {
        self.init()
        self.nickname = nickname
        self.profile = profile
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(profile, forKey: .profile)
    }
}
