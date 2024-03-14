//
//  PosterbaseURL.swift
//  UQuiz
//
//  Created by Greed on 3/9/24.
//

import Foundation

enum PosterURL {
    case imageURL(detailURL: String)
    case thumbnailURL(detailURL: String)
    
    var endpoint: URL {
        switch self {
        case .imageURL(let detailURL):
            return URL(string: "https://image.tmdb.org/t/p/w500\(detailURL)")!
        case .thumbnailURL(detailURL: let detailURL):
            return URL(string: "https://image.tmdb.org/t/p/w154\(detailURL)")!
        }
    }
     
}
