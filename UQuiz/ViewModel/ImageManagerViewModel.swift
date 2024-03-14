//
//  ImageManagerViewModel.swift
//  UQuiz
//
//  Created by Greed on 3/14/24.
//

import UIKit

class ImageManagerViewModel {
    
    enum UserProfile: String {
        case customProfile
    }
    
    let imageManager = ImageFileManager.shared
    
    var inputUserProfileImage: Observable<UIImage?> = Observable(nil)
    var inputUserProfileSaveTrigger: Observable<Void?> = Observable(nil)
    
    var outputUserProfileImage: Observable<UIImage?> = Observable(nil)
    
    init() {
        inputUserProfileImage.noInitBind { image in
            guard let image = image else { return }
            self.outputUserProfileImage.value = image
        }
        inputUserProfileSaveTrigger.noInitBind { _ in
            self.profileImageSave()
        }
    }
    
    private func profileImageSave() {
        guard let image = outputUserProfileImage.value else { return }
        imageManager.saveImageToDocument(image: image, filename: UserProfile.customProfile.rawValue)
    }
    
//    private func loadImage() {
//        imageManager.loadImageFromDocument(filename: <#T##String#>)
//    }
//    
//    private func removeImage() {
//        imageManager.removeImageFromDocument(filename: <#T##String#>)
//    }
}
