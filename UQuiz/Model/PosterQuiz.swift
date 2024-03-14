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
    var selectedArea: [Int]
    var numberOfselectArea: Int
    
    init(item: Movie) {
        self.id = item.id
        self.genre = item.genre
        self.poster = item.poster
        self.title = item.title
        var tmp: [Int] = []
        for _ in 0...1943 {
            tmp.append(0)
        }
        self.selectedArea = tmp
        self.numberOfselectArea = 0
    }
}
