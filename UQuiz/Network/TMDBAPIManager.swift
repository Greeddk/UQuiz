//
//  TMDBAPI.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation
import Alamofire
import os

final class TMDBAPIManager {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "APIManger")
    static let shared = TMDBAPIManager()
    
    func requestMovieInfo<T:Decodable>(type: T.Type, query: String, completionHandler: @escaping (T) -> Void) {
        AF.request(Router.search(["query": query, "language": "ko-KR"])).responseDecodable(of: type) { response in
            switch response.result {
            case .success(let success):
                if response.response?.statusCode == 200 {
                    completionHandler(success)
                } else if response.response?.statusCode == 500 {
                    self.logger.error("statusCode Error")
                }
            case .failure(let failure):
                self.logger.error("통신 에러 \(failure)")
            }
        }
        
    }
    
    func requestPosters(id: Int, completionHandler: @escaping (Posters) -> Void) {
        AF.request(Router.posters(id)).responseDecodable(of: Posters.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                self.logger.error("통신 에러 \(failure)")
            }
        }
    }
    
}
