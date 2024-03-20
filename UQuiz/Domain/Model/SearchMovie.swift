//
//  SearchMovie.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

struct SearchMovie: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, Hashable, Identifiable {
    let id: Int
    let genre: [Int]?
    var poster: String?
    let overview: String
    let title: String
    let original_title: String
    let release_date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case genre = "genre_ids"
        case poster = "poster_path"
        case overview
        case title
        case original_title
        case release_date
    }
}
