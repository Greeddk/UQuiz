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
    private let fileManager = FileManager.default
    
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
        return RealmPosterQuiz(movieId: quiz.id, genre: tmpGenre, poster: quiz.poster ?? "", title: quiz.title, original_title: quiz.original_title, selectedArea: tmpSelectedList, numberOfselectArea: quiz.numberOfselectArea, overview: quiz.overview, release_date: quiz.release_date)
    }
    
    func createPackage(package: [PosterQuiz], title: String, makerInfo: RealmMakerInfo, level: Level) {
        let tmp = List<RealmPosterQuiz>()
        package.forEach {
            tmp.append(changeModelToRealmObject(quiz: $0))
        }
        let quizPackage = RealmPosterQuizPackage(title: title, quizs: tmp, maker: makerInfo, level: level.rawValue)
        do {
            try realm.write { 
                realm.add(quizPackage)
            }
        } catch {
            print("createpackage error")
        }
    }
    
    func updateQuizIsCorrect(_ quiz: RealmPosterQuiz, isCorrect: Bool) {
        do {
            try realm.write {
                quiz.isCorrect = isCorrect
            }
        } catch {
            print("update Quiz Error")
        }
    }
    
    func fetchPackages() -> [RealmPosterQuizPackage] {
        return Array(realm.objects(RealmPosterQuizPackage.self).reversed())
    }
    
    func deletePackage(package: RealmPosterQuizPackage) {
        do {
            try realm.write {
                package.quizs.forEach { quiz in
                    realm.delete(quiz)
                }
                realm.delete(package)
            }
        } catch {
            print("delete Package Error")
        }
    }
    
    func fetchInitialData() {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("InitialData.realm")

        do {
            let initialRealm = try Realm(fileURL: fileURL)
            try realm.write {
                let quizPackages = initialRealm.objects(RealmPosterQuizPackage.self)

                let sortedQuizPackages = quizPackages.sorted { $0.level > $1.level }
                for object in sortedQuizPackages {
                    realm.create(RealmPosterQuizPackage.self, value: object, update: .modified)
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func copyInitialRealm() {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("InitialData.realm")
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            let bundleURL = Bundle.main.url(forResource: "initial", withExtension: "realm")!
            
            do {
                try fileManager.copyItem(at: bundleURL, to: fileURL)
            } catch {
                print("Error copy file: \(error)")
            }
        }
    }
    
}
