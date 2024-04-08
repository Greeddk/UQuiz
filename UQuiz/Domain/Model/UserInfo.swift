//
//  UserInfo.swift
//  UQuiz
//
//  Created by Greed on 4/8/24.
//

import Foundation
import UIKit

final class UserInfo: Identifiable {
    var uuid = UUID()
    var name = UserDefaults.standard.string(forKey: "username") ?? ""
    var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
    var profileImage: [Int] = (UserDefaults.standard.array(forKey: "profileArr") as? [Int]) ?? []
    var myMissionPhoto: UIImage? = UIImage(named: "GU2")
    var myMission: String = ""
    //    @Published var userHistory = UserHistory()
    
    func updateUserInfo() {
        self.name = UserDefaults.standard.string(forKey: "username") ?? ""
        self.profileImageURL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
        self.profileImage = (UserDefaults.standard.array(forKey: "profileArr") as? [Int]) ?? []
        
        //        print("userinfo update = \(name), \(profileImageURL)!!")
    }
}


extension UserInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case profileImageURL
        case profileImage
        case myMissionPhoto
        case myMisssion
        //        case userHistory
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(profileImageURL, forKey: .profileImageURL)
        try container.encode(profileImage, forKey: .profileImage)
        if let imageData = myMissionPhoto?.jpegData(compressionQuality: 0.8) {
            try container.encode(imageData, forKey: .myMissionPhoto)
        }
        try container.encode(myMission, forKey: .myMisssion)
        //        try container.encode(userHistory, forKey: .userHistory)
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        profileImageURL = try container.decode(URL.self, forKey: .profileImageURL)
        profileImage = try container.decode([Int].self, forKey: .profileImage)
        if let imageData = try container.decode(Data?.self, forKey: .myMissionPhoto) {
            myMissionPhoto = UIImage(data: imageData) ?? UIImage()
        }
        myMission = try container.decode(String.self, forKey: .myMisssion)
        //        userHistory = try container.decode(UserHistory.self, forKey: .userHistory)
    }
    
}

func encodeUserInfo(_ userInfo: UserInfo) -> Data? {
    let encoder = JSONEncoder()
    do {
        return try encoder.encode(userInfo)
    } catch {
        print("Error encoding UserInfo: \(error)")
        return nil
    }
}

func decodeUserInfo(_ data: Data) -> UserInfo? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(UserInfo.self, from: data)
    } catch {
        print("Error decoding UserInfo: \(error)")
        return nil
    }
}

// Encode user info array
func encodeUserInfoArray(_ userInfoArray: [UserInfo]) -> Data? {
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(userInfoArray)
        return data
    } catch {
        print("Encode User Info Array Error: \(error.localizedDescription)")
        return nil
    }
}

// Decode user info array
func decodeUserInfoArray(from data: Data) -> [UserInfo]? {
    do {
        let decoder = JSONDecoder()
        let userInfoArray = try decoder.decode([UserInfo].self, from: data)
        return userInfoArray
    } catch {
        print("Decode User Info Array Error: \(error.localizedDescription)")
        return nil
    }
}
