//
//  TMDBAPI.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case get([String: String])
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.tmdb]
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .get:
            return "search/movie"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case let .get(Parameters):
            request = try URLEncodedFormParameterEncoder().encode(Parameters, into: request)
        }

        return request
    }
}

