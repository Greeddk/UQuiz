//
//  PosterbaseURL.swift
//  UQuiz
//
//  Created by Greed on 3/9/24.
//

import Foundation

enum PosterURL {
    case imageURL(detailURL: String)
    
    var endpoint: URL {
        switch self {
        case .imageURL(let detailURL):
            return URL(string: "https://image.tmdb.org/t/p/w500\(detailURL)")!
        }
    }
     
}
