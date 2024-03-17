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
        let tmpGenre = List<Int>()
        quiz.genre?.forEach({
            tmpGenre.append($0)
        })
        let tmpSelectedList = List<RealmSelectedArea>()
        quiz.selectedArea.forEach { value in
            let tmp = RealmSelectedArea()
            tmp.area.append(objectsIn: value)
            tmpSelectedList.append(tmp)
        }
        return RealmPosterQuiz(movieId: quiz.id, genre: tmpGenre, poster: quiz.poster ?? "", title: quiz.title, selectedArea: tmpSelectedList, numberOfselectArea: quiz.numberOfselectArea)
    }
    
    func createPackage(package: [PosterQuiz], title: String, makerInfo: RealmMakerInfo) {
        let tmp = List<RealmPosterQuiz>()
        package.forEach {
            tmp.append(changeModelToRealmObject(quiz: $0))
        }
        let quizPackage = RealmPosterQuizPackage(title: title, quizs: tmp, maker: makerInfo)
        do {
            try realm.write {
                realm.add(quizPackage)
            }
        } catch {
            print("createpackage error")
        }
    }
    
    func fetchPackages() -> [RealmPosterQuizPackage] {
        print(realm.configuration.fileURL)
        return Array(realm.objects(RealmPosterQuizPackage.self))
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
