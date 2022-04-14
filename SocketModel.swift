//
//  SocketModel.swift
//  PlayerSocket
//
//  Created by 김원철 on 2022/04/13.
//

import Foundation
import SocketIO

public struct PlayerSocket {
    // MARK: - REQUEST | SOCKETDATA
    // socket emit 시 인증 정보 담을 수 있는 구조체
    public struct Auth: SocketData {
        let isAdmin : Bool?
        let token : String?
        let userId : String?
        public func socketRepresentation() -> SocketData {
            return ["isAdmin": isAdmin, "token": token, "userId": userId]
        }
    }

    // socket emit init 요청에 대한 구조체
    public struct Init: SocketData {
        let roomId : String?
        let auth : Auth?
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId, "auth": auth?.socketRepresentation()]
        }
    }
    
    // socket emit sendMessage에 대한 구조체
    public struct sendMessage: SocketData {
        let roomId: String?
        let isAdmin: Bool?
        let messageInput: MessageInput?
        
        public struct MessageInput {
            let partnerId: String?
            let messageType: Int?
            let message: String?
            let userNick: String?
            let isLive: Bool?
            let userName: String?
            let userId: String?
            let roomId: String?
            let data = "none"
            
            public func socketRepresentation() -> SocketData {
                return ["partnerId": partnerId, "messageType": messageType, "message": message, "userNick": userNick, "isLive": isLive, "userName": userName, "userId": userId, "roomId": roomId, "data": data]
            }
        }
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId, "isAdmin": isAdmin, "input": messageInput?.socketRepresentation()]
        }
    }
    
    // socket emit sendLike 요청에 대한 구조체
    public struct sendLike: SocketData {
        let roomId : String?
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId, "value": 1]
        }
    }
    
    

    // MARK: - Response | Codable
    public struct BanUserInfo : Codable {
        var userId : [String]?
    }

    public struct BannedWordInfo : Codable {
        var bannedWord : [String]?
    }

    public struct Room : Codable {
        public var banUserInfo : BanUserInfo?
        public var bannedWordInfo : BannedWordInfo?
        public var canChat : Bool?
        public var chatCounterInfo : Int64?
        public var currentPurchase : Bool?
        public var currentQuiz : Bool?
        public var currentWinPurchase : Bool?
        public var incomingCounterInfo : Int64?
        public  var publishDate : String?
        public var reactionCounterInfo : Int64?
        public var regDate : String?
        public var roomId : String?
        public var roomState : Int?
        public var streamInfo : String?
        public var title : String?
        public var updateDt : String?
    }

    public struct JoinUser : Codable {
        var isLive : Bool?
        var message : String?
        var messageId : String?
        var messageType : Int?
        var partnerId : String?
        var regDate : String?
        var roomId : String?
        var userId : String?
        var userName : String?
        var userNick : String?
    }

    public struct InitModel : Codable {
        public var currentDt : String?
        public var joinUser : [JoinUser]?
        public var liveUserCount : Int64?
        public var room : Room?
        public var socketUpdateRoomName : String?
    }

    public struct UpdateRoomModel : Codable {
        public var joinUser : [JoinUser]?
        public var liveUserCount : Int64?
        public var room : Room?
        public var roomId : String?
    }

    public struct MessageModel: Codable {
        let regDate: String?
        let isAdmin: Bool?
        let message: String?
        let messageId: String?
        let partnerId: String?
        let messageType: Int?
        let deleteOwner: String?
        let isLive: Bool?
        let roomId: String?
        let userId: String?
        let userName: String?
        let data: String?
        let updateDt: String?
        let inactive: Bool?
        let userNick: String?
    }
    
    public struct LikeModel: Codable {
        let roomId: String?
        let value: Int?
    }

}

