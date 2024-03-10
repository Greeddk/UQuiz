//
//  TMDBAPI.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation
import Alamofire
import os

class TMDBAPIManager {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "APIManger")
    static let shared = TMDBAPIManager()
    
    static var id: Int = 0
    
    func requestMovieInfo<T:Decodable>(type: T.Type, query: String, completionHandler: @escaping (T) -> Void) {
        AF.request(Router.get(["query": query, "language": "ko-KR"])).responseDecodable(of: type) { response in
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
    
}
