//
//  SearchMovie.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

struct SearchMovie {
    let result: [Movie]
}

struct Movie {
    let genre: [Int]
    let poster: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case genre = "genre_ids"
        case poster = "poster_path"
        case title
    }
}
