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
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case poster = "file_path"
        case country = "iso_639_1"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.poster = try container.decode(String.self, forKey: .poster)
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? "zz"
    }
}
