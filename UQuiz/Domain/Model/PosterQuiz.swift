//
//  Quiz.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import Foundation

struct PosterQuiz: Codable {
    let id: Int
    let genre: [Int]?
    var poster: String?
    let title: String
    let original_title: String
    var selectedArea: [[Int]]
    var numberOfselectArea: Int
    let overview: String
    let release_date: String
    
    init(item: Movie) {
        self.id = item.id
        self.genre = item.genre
        self.poster = item.poster
        self.title = item.title
        self.original_title = item.original_title
        self.selectedArea = []
        self.numberOfselectArea = 0
        self.overview = item.overview
        self.release_date = item.release_date ?? ""
    }
}

extension PosterQuiz {
    init(id: Int, genre: [Int]?, poster: String?, title: String, original_title: String, selectedArea: [[Int]], numberOfselectArea: Int, overview: String, release_date: String) {
        self.id = id
        self.genre = genre
        self.poster = poster
        self.title = title
        self.original_title = original_title
        self.selectedArea = selectedArea
        self.numberOfselectArea = numberOfselectArea
        self.overview = overview
        self.release_date = release_date
    }
}
