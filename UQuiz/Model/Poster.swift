//
//  Poster.swift
//  UQuiz
//
//  Created by Greed on 3/12/24.
//

import Foundation

struct Posters: Decodable {
    let posters: [Poster]
}

struct Poster: Decodable {
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case poster = "file_path"
    }
}
