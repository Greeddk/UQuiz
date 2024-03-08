//
//  MoviePackage.swift
//  UQuiz
//
//  Created by Greed on 3/8/24.
//

import Foundation

struct MoviePackage: Decodable {
    let name: String
    let maker: String
    let movieList: [Movie]
    
    var quizCount: Int {
        return movieList.count
    }
}
