//
//  ImageManagerViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/14/24.
//

import UIKit

final class ProfileManagerViewModel {
    
    private let imageManager = ImageFileManager.shared
    private let udManager = UserDefaultsManager.shared
    private let makerRepository = MakerInfoRepository()
    
    var inputUserProfileImage: Observable<UIImage?> = Observable(nil)
    var inputUserProfileSaveTrigger: Observable<Void?> = Observable(nil)
    var inputLoadProfileImageTrigger: Observable<Void?> = Observable(nil)
    var inputUserNickname: Observable<String> = Observable("")
    
    var outputUserProfileImage: Observable<UIImage?> = Observable(nil)
    var outputNickname: Observable<String> = Observable("")
    
    init() {
        createMakerInfo()
        inputUserProfileImage.noInitBind { image in
            self.outputUserProfileImage.value = image
        }
        inputUserProfileSaveTrigger.noInitBind { _ in
            self.profileImageSave()
        }
        inputLoadProfileImageTrigger.bind { [weak self] _ in
            self?.fetchInfo()
        }
    }
    
    private func fetchInfo() {
        outputUserProfileImage.value = loadImage()
        let info = makerRepository.fetchMakerInfo()
        outputNickname.value = info.nickname
    }
    
    private func createMakerInfo() {
        if !udManager.userState {
            makerRepository.createProfile(nickname: "", profile: nil)
        }
    }
    
    private func profileImageSave() {
        // 1. userState = false 일때, 처음 들어왓을 때, RealmMakerInfo 생성
        // 2. 완료 버튼 누르는 순간 업데이트
        // 3. 이미지는 ObjectID로 저장
        
        // 만약 기존 사진이 있다면, 그 사진을 찾아서 삭제 한후
        // 새로운 사진을 저장하고, 사진 이름도 저장
        if let image = loadImage() {
            removeImage()
        }
        
        if let pickedImage = outputUserProfileImage.value {
            let info = makerRepository.fetchMakerInfo()
            imageManager.saveImageToDocument(image: pickedImage, filename: "\(info.id)")
            handleProfileImageUpdate(profileImage: "\(info.id)")
        } else {
            handleProfileImageUpdate(profileImage: nil)
        }

    }
    
    private func handleProfileImageUpdate(profileImage: String?) {
        makerRepository.updateMakerInfo(nickname: inputUserNickname.value, profile: profileImage)
    }
    
    
    private func loadImage() -> UIImage? {
        let info = makerRepository.fetchMakerInfo()
        return imageManager.loadImageFromDocument(filename: "\(info.id)")
    }
    
    private func removeImage() {
        let info = makerRepository.fetchMakerInfo()
        imageManager.removeImageFromDocument(filename: "\(info.id)")
    }
    
}
