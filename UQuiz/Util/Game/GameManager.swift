//
//  GameManager.swift
//  UQuiz
//
//  Created by Greed on 4/1/24.
//

import Foundation
import GameKit

final class GameManager {
    static let shared = GameManager()
    
    var localPlayer = GKLocalPlayer.local
    var authenticationState: PlayerAuthState = .unauthenticated
    
    private var rootViewController: UIViewController? {
        let windowsence = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowsence?.windows.first?.rootViewController
    }
    
    enum PlayerAuthState: String {
        case authenticating = "Logging in to Game Center..."
        case unauthenticated = "Please sign in to Game Center to play."
        case authenticated = ""
        
        case error = "There was an error, logging into Game Center."
        case restricted = "You're not allowed to play multiplayer games!"
    }
    
    func authenticateUser() {
        print("유저 인증 시작")
        GKLocalPlayer.local.authenticateHandler = { [self] viewc, error in
            if let viewContorller = viewc {
                rootViewController?.present(viewContorller, animated: true)
                return
            } // GameKit내부의 로그인 ViewController를 띄워줌
            if let error = error {
                authenticationState = .error
                print(error.localizedDescription)
                return
            } // 에러처리
            if localPlayer.isAuthenticated { //localPlayer = GKLocalPlayer.local
                if localPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                    print(authenticationState)
                } else {
                    authenticationState = .authenticated
                    print(authenticationState)
                }
            } else {
                authenticationState = .unauthenticated
            } // 로그인 후 현재 사용자의 상태에 따라 값을 설정
        }
    }
    

}
