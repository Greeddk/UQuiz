//
//  TMDBAPI.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation
import Alamofire

enum TMDBAPI {
    case imageURL(imageURL: String)
    case movieSearchURL(query: String)
    
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.tmdb]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var paremeter: Parameters {
        switch self {
        case .imageURL:
            return [:]
        case .movieSearchURL(let query):
            return [ "query": query, "language": "ko-KR"]
        }
    }
    
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    var endpoint: URL {
        switch self {
        case .imageURL(let imageURL):
            return URL(string: "https://image.tmdb.org/t/p/w500" + imageURL)!
        case .movieSearchURL(let query):
            return URL(string: baseURL + "/search/movie")!
        }
    }
}
