//
//  SceneDelegate.swift
//  UQuiz
//
//  Created by Greed on 3/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var blurView: UIVisualEffectView?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let value = UserDefaultsManager.shared.userState
        
        if value {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = SetProfileViewController()
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        if let blurView = blurView {
            blurView.removeFromSuperview()
        }
        NotificationCenter.default.post(name: Notification.Name("SceneResign"), object: nil, userInfo: ["willResign": false])
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        guard let window = window else {
            return
        }

        NotificationCenter.default.post(name: Notification.Name("SceneResign"), object: nil, userInfo: ["willResign": true])
        
        let effect = UIBlurEffect(style: .regular)
        blurView = UIVisualEffectView(effect: effect)
        blurView?.frame = window.frame
        window.addSubview(blurView!)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("background")
        NotificationCenter.default.post(name: Notification.Name("SceneResign"), object: nil, userInfo: ["willResign": true])
    }
    
}
