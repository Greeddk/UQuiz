//
//  GameManager.swift
//  UQuiz
//
//  Created by Greed on 4/1/24.
//

import Foundation
import GameKit

final class GameManager: NSObject {
    
    static let shared = GameManager()
    
    var authenticationState: PlayerAuthState = .unauthenticated
    
    private var matchRequest: GKMatchRequest = GKMatchRequest() // 매칭의 각종 설정을 넣어줄 수 있음 최소, 최대인원수, 그룹번호 등
    private var matchmakingMode: GKMatchmakingMode = .default // 매칭 관련 옵션설정
    private var matchmaker: GKMatchmaker? // 매칭을 시작하게 하는 객체
    
    var match: GKMatch? // 매칭이 성공적으로 되었을 때 넣어둘 매칭 친구
    var localPlayer = GKLocalPlayer.local // 내 인증한 계정
    var otherPlayer: [GKPlayer]? // GKPlayer == 다른 사람들 저장해둘 수도 있고 그외에 처리할 때도 쓰임
    var groupNumber = ""
    var otherPlayerInfo: [UserInfo]? = []
    var localPlayerInfo: UserInfo?
    var isHost = false // host인지 아닌지 판단
    var hostPlayer: String?
    var gameState: GameSessionState = .idle
    
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
    
    enum GameSessionState {
        case idle
        case matchmaking
        case inGame
        case shared
    }
    
    func authenticateUser() {
        print("유저 인증 시작")
        GKLocalPlayer.local.authenticateHandler = { [self] viewc, error in
            if let viewContorller = viewc {
                rootViewController?.present(viewContorller, animated: true)
                return
            }
            if let error = error {
                authenticationState = .error
                print(error.localizedDescription)
                return
            }
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                    print(authenticationState)
                } else {
                    authenticationState = .authenticated
                    print(authenticationState)
                }
            } else {
                authenticationState = .unauthenticated
            }
        }
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest() // 매칭 설정 셋팅하기위해
        request.minPlayers = 2 // 최소 인원을 2명으로
        request.maxPlayers = 2 // 최대인원은 사용자에게 받아온 인원
        request.playerGroup = Int(groupNumber)! // 숫자코드로 원하는사람들끼리 매칭하는 기능
        matchRequest = request // 선언해두었던 곳으로 옮기는 과정
        
        matchmaker = GKMatchmaker.shared()
        matchmaker?.findMatch(for: matchRequest, withCompletionHandler: { [weak self] (match, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let match = match {
                self?.startGame(newMatch: match)
            }
        })
    }
    
    func startGame(newMatch: GKMatch) {
        newMatch.delegate = self
        match = newMatch
        
        if let match = match, match.players.isEmpty {
            otherPlayer = newMatch.players
            //            inGame = true
        } else {
            print("player info nothing..")
        }
    }
    
    func generateRandomPlayCode() {
        let randomNumber = Int.random(in: 0...9999)
        groupNumber = String(format: "%04d", randomNumber)
    }
    
    
}

extension GameManager: GKMatchDelegate {
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print(#function)
        switch gameState {
        case .matchmaking:
            if !isHost {
                let content = String(decoding: data, as: UTF8.self)
                if content.starts(with: "strData") {
                    let message = content.replacing("strData:", with: "")
                    receivedString(message)
                }
                //                gameState = .inGame
            } else {
                if let content = decodeUserInfo(data) {
                    DispatchQueue.main.async { [self] in
                        if let index = otherPlayerInfo?.firstIndex(where: { $0.uuid == content.uuid }) {
                            // If an element with the same uuid exists, replace it
                            otherPlayerInfo?[index] = content
                            sendUserInfo()
                        } else {
                            // If the uuid doesn't exist, append the new element
                            otherPlayerInfo?.append(content)
                            sendUserInfo()
                        }
                    }
                } else {
                    //                    sendUserInfo()
                }
            }
        case .inGame:
            if let content = decodeUserInfo(data) {
                DispatchQueue.main.async { [self] in
                    if let index = otherPlayerInfo?.firstIndex(where: { $0.uuid == content.uuid }) {
                        // If an element with the same uuid exists, replace it
                        otherPlayerInfo?[index] = content
                    } else {
                        // If the uuid doesn't exist, append the new element
                        otherPlayerInfo?.append(content)
                    }
                }
            } else {
                if let content = decodeUserInfoArray(from: data) {
                    DispatchQueue.main.async {
                        self.otherPlayerInfo = self.filterAndRemoveOwnUserInfo(from: content)
                    }
                } else {
                    //                    sendUserInfo()
                }
            }
        case .idle:
            print("아직 게임 매칭상태도아님.")
        case .shared:
            print("shared게임상태로 들어감")
            if isHost {
                if let content = decodeUserInfo(data) {
                    DispatchQueue.main.async { [self] in
                        if let index = otherPlayerInfo?.firstIndex(where: { $0.uuid == content.uuid }) {
                            // If an element with the same uuid exists, replace it
                            otherPlayerInfo?[index] = content
                            otherPlayerInfo?.insert(localPlayerInfo!, at: 0)
                        } else {
                            // If the uuid doesn't exist, append the new element
                            otherPlayerInfo?.append(content)
                            otherPlayerInfo?.insert(localPlayerInfo!, at: 0)
                        }
                    }
                }
            } else {
                if let content = decodeUserInfoArray(from: data) {
                    DispatchQueue.main.async {
                        var arr = self.filterAndRemoveOwnUserInfo(from: content)
                        arr.insert(self.localPlayerInfo!, at: 0)
                        self.otherPlayerInfo = arr
                    }
                } else {
                    //                    sendUserInfo()
                }
            }
        }
        
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print(#function)
        //        guard let user = localPlayerInfo else { return }
        switch state {
        case .connected:
            print("DEBUG: localplayer = \(localPlayer.displayName), otherplayer = \(player.displayName)")
            if isHost {
                hostPlayer = localPlayer.displayName
                guard let host = hostPlayer else { print("ishost, host optional and nil !")
                    return }
                sendString(host)
            }
            //            DispatchQueue.main.async {
            //                guard let host = self.hostPlayer else { return }
            //                self.sendString("began: \(host.gamePlayerID)")
            //                self.otherPlayer?.append(player)
            //                self.sendString("began: \(user.name)")
            //                self.sendUserInfo()
            //            }
        case .disconnected:
            print("플레이어\(player.displayName)의 연결이 끊김")
        case .unknown:
            print("\(player.displayName)의 연결상태 모름")
        @unknown default:
            break
        }
        
    }
    
}

extension GameManager {
    
    func receivedString(_ message: String) {
        print(#function)
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        //        let parameter = String(messageSplit.last ?? "")
        switch messagePrefix {
        case "began":
            print("began????")
        default:
            hostPlayer = match?.players.first(where: { $0.displayName == message })?.displayName
            sendUserInfo()
            DispatchQueue.main.async {
                self.gameState = .inGame
            }
        }
    }
    
    func sendString(_ message: String) {
        print(#function)
        print("DEBUG: send string = \(message)")
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
    }
    
    func sendUserInfo() {
        guard let info = localPlayerInfo else { return }
        if isHost {
            guard var infoarr = otherPlayerInfo else { return }
            infoarr.append(info)
            if let data = encodeUserInfoArray(infoarr) {
                sendData(data, mode: .reliable)
            }
            
        } else {
            //        info.myMissionPhoto
            if let data = encodeUserInfo(info) {
                sendData(data, mode: .reliable)
            }
        }
    }
    
    //    func sendMissionImage() {
    //        sendUserInfo()
    //    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        if isHost {
            do {
                print("호스트 보냄")
                try match?.sendData(toAllPlayers: data, with: mode)
            } catch {
                print("데이터 보내기 에러 = \(error.localizedDescription)")
            }
        } else {
            print("비호스트가 보냄")
            guard let host = match?.players.first(where: { $0.displayName == hostPlayer }) else {
                print("데이터 보내는과정에서 호스트를 못찾음")
                return }
            do {
                try match?.send(data, to: [host], dataMode: mode)
            } catch {
                print("데이터 보내기 에러 = \(error.localizedDescription)")
            }
        }
        
    }
    
    // Filter and remove own user info from array
    func filterAndRemoveOwnUserInfo(from array: [UserInfo]) -> [UserInfo] {
        return array.filter { $0.uuid != localPlayerInfo?.uuid }
    }
}
