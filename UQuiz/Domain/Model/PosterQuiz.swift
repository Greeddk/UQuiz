//
//  Quiz.swift
//  UQuiz
//
//  Created by Greed on 3/13/24.
//

import Foundation

struct PosterQuiz {
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
