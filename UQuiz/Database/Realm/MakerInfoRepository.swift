//
//  MakerInfoRepository.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation
import RealmSwift

final class MakerInfoRepository {
    
    private let realm = try! Realm()
    
    func createProfile(nickname: String, profile: String) {
        let data = RealmMakerInfo(nickname: nickname, profile: profile)
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("makerInfo Create Error")
        }
    }
    
    func fetchMakerInfo() -> RealmMakerInfo {
        guard let maker = Array(realm.objects(RealmMakerInfo.self)).first else { return RealmMakerInfo(nickname: "", profile: "") }
        return maker
    }
    
    func updateMakerInfo(nickname: String?, profile: String?) {
        var maker = fetchMakerInfo()
        do {
            try realm.write {
                maker.nickname = nickname ?? maker.nickname
                maker.profile = profile ?? maker.profile
            }
        } catch {
            print("makerInfo update Error")
        }
    }
    
}
