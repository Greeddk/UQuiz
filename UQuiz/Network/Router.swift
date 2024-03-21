//
//  TMDBAPI.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case search([String: String])
    case posters(Int)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.tmdb]
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        case .posters:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "search/movie"
        case .posters(let id):
            return "movie/\(id)/images"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case let .search(Parameters):
            request = try URLEncodedFormParameterEncoder().encode(Parameters, into: request)
        case .posters(_):
            return request
        }
        return request
    }
}

