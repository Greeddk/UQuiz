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
        inputUserProfileImage.noInitBind { image in
            self.outputUserProfileImage.value = image
        }
        inputUserProfileSaveTrigger.noInitBind { _ in
            self.profileImageSave()
        }
        inputLoadProfileImageTrigger.bind { _ in
            self.outputUserProfileImage.value = self.loadImage()
            self.outputNickname.value = self.udManager.nickname
        }
    }
    
    private func profileImageSave() {

        let image = loadImage()
        udManager.nickname = inputUserNickname.value

        if let pickedImage = outputUserProfileImage.value {
            imageManager.saveImageToDocument(image: pickedImage, filename: inputUserNickname.value + "profile")
            udManager.profileImage = inputUserNickname.value + "profile"
            handleProfileImageUpdate(profileImage: udManager.profileImage)
        } else {
            handleProfileImageUpdate(profileImage: nil)
        }
    }

    private func handleProfileImageUpdate(profileImage: String?) {
        if !udManager.userState {
            makerRepository.createProfile(nickname: udManager.nickname, profile: profileImage)
        } else {
            makerRepository.updateMakerInfo(nickname: udManager.nickname, profile: profileImage)
        }
    }

    
    private func loadImage() -> UIImage? {
        imageManager.loadImageFromDocument(filename: udManager.profileImage + "profile")
    }

    private func removeImage() {
        let originImage = udManager.profileImage
        imageManager.removeImageFromDocument(filename: originImage + "profile")
    }
    
}
