//
//  PosterQuizPackageRepository.swift
//  UQuiz
//
//  Created by Greed on 3/16/24.
//

import Foundation
import RealmSwift

final class PosterQuizPackageRepository {
    
    private let realm = try! Realm()
    
    private func changeModelToRealmObject(quiz: PosterQuiz) -> RealmPosterQuiz {
        var tmpGenre = List<Int>()
        quiz.genre?.forEach({
            tmpGenre.append($0)
        })
        let tmpSelectedArea = List<Int>()
        quiz.selectedArea.forEach { value in
            tmpSelectedArea.append(value)
        }
        return RealmPosterQuiz(id: quiz.id, genre: tmpGenre, poster: quiz.poster ?? "", title: quiz.title, selectedArea: tmpSelectedArea, numberOfselectArea: quiz.numberOfselectArea)
    }
    
    func createPackage(package: [PosterQuiz], title: String, makerInfo: RealmMakerInfo) {
        var tmp = List<RealmPosterQuiz>()
        package.forEach {
            tmp.append(changeModelToRealmObject(quiz: $0))
        }
        let quizPackage = RealmPosterQuizPackage(title: title, quizs: tmp, maker: makerInfo)
    }
    
    func fetchPackages() -> [RealmPosterQuizPackage] {
        Array(realm.objects(RealmPosterQuizPackage.self))
    }
    
    func deletePackage(package: RealmPosterQuizPackage) {
        do {
            try realm.write {
                realm.delete(package)
            }
        } catch {
            print("delete Package Error")
        }
    }
    
}