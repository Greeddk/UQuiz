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

    static let shared = TMDBAPIManager()
    
    func requestMovieInfo<T:Decodable>(type: T.Type, query: String, completionHandler: @escaping (T) -> Void) {
        AF.request(Router.search(["query": query, "language": "ko-KR"])).responseDecodable(of: type) { response in
            switch response.result {
            case .success(let success):
                if response.response?.statusCode == 200 {
                    completionHandler(success)
                } else if response.response?.statusCode == 500 {
                    print("statusCode Error")
                }
            case .failure(let failure):
                print("통신 에러 \(failure)")
            }
        }
        
    }
    
    func requestPosters(id: Int, completionHandler: @escaping ([Poster]) -> Void) {
        AF.request(Router.posters(id)).responseDecodable(of: Posters.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.posters)
            case .failure(let failure):
                print("통신 에러 \(failure)")
            }
        }
    }
    
}
