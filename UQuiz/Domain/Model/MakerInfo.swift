//
//  MakerInfo.swift
//  UQuiz
//
//  Created by Greed on 3/24/24.
//

import Foundation

struct MakerInfo: Codable {
    let nickname: String
    let profile: String
    
    init(realmMakerInfo: RealmMakerInfo) {
        self.nickname = realmMakerInfo.nickname
        self.profile = realmMakerInfo.profile
    }
}
