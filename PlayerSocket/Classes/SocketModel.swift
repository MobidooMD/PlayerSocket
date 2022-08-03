//
//  SocketModel.swift
//  PlayerSocket
//
//  Created by 김원철 on 2022/04/13.
//

import Foundation
import SocketIO

public struct PlayerSocketModel {
    // MARK: - REQUEST | SOCKETDATA
    // socket emit 시 인증 정보 담을 수 있는 구조체
    public struct Auth: SocketData {
        public let isAdmin : Bool?
        public let token : String?
        public let userID : String?
        public func socketRepresentation() -> SocketData {
            return ["isAdmin": isAdmin ?? false, "token": token ?? "", "userId": userID ?? ""]
        }
    }

    // socket emit init 요청에 대한 구조체
    public struct Init: SocketData {
        public let roomID : String?
        public let auth : Auth?
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomID, "auth": auth?.socketRepresentation()]
        }
    }
    
    // socket emit sendMessage에 대한 구조체
    public struct sendMessage: SocketData {
        public let roomID: String?
        public let isAdmin: Bool?
        public let messageInput: MessageInput?
        
        public init(roomID: String, isAdmin: Bool, messageInput: MessageInput) {
            self.roomID = roomID
            self.isAdmin = isAdmin
            self.messageInput = messageInput
        }
        
        public struct MessageInput {
            public let partnerID: String?
            public let messageType: Int?
            public let message: String?
            public let userNick: String?
            public let isLive: Bool?
            public let userName: String?
            public let userID: String?
            public let roomID: String?
            public var data = "none"
            
            public init(partnerID: String, messageType: Int, message: String, userNick: String, isLive: Bool, userName: String, userID: String, roomID: String, data: String = "none") {
                self.partnerID = partnerID
                self.messageType = messageType
                self.message = message
                self.userNick = userNick
                self.isLive = isLive
                self.userName = userName
                self.userID = userID
                self.roomID = roomID
                self.data = data
              }
            
            public func socketRepresentation() -> SocketData {
                return ["partnerId": partnerID ?? "", "messageType": messageType ?? 0, "message": message ?? "", "userNick": userNick ?? "", "isLive": isLive ?? false, "userName": userName ?? "", "userId": userID ?? "", "roomId": roomID ?? "", "data": data]
            }
        }
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId, "isAdmin": isAdmin, "input": messageInput?.socketRepresentation()]
        }
    }
    
    // socket emit sendLike 요청에 대한 구조체
    public struct sendLike: SocketData {
        public let roomID : String?
        
        public init(roomID: String) {
            self.roomID = roomID
        }
        
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomID ?? "", "value": 1]
        }
    }
    
    

    // MARK: - Response | Codable
    public struct BanUserInfo : Codable {
        public var userID : [String]?
    }

    public struct BannedWordInfo : Codable {
        public var bannedWord : [String]?
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
        public var publishDate : String?
        public var reactionCounterInfo : Int64?
        public var regDate : String?
        public var roomID : String?
        public var roomState : Int?
        public var streamInfo : String?
        public var title : String?
        public var updateDt : String?
    }

    public struct JoinUser : Codable {
        public var isLive : Bool?
        public var message : String?
        public var messageID : String?
        public var messageType : Int?
        public var partnerID : String?
        public var regDate : String?
        public var roomID : String?
        public var userID : String?
        public var userName : String?
        public var userNick : String?
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
        public var roomID : String?
    }

    public struct MessageModel: Codable {
        public let regDate: String?
        public let isAdmin: Bool?
        public let message: String?
        public let messageID: String?
        public let partnerID: String?
        public let messageType: Int?
        public let deleteOwner: String?
        public let isLive: Bool?
        public let roomID: String?
        public let userID: String?
        public let userName: String?
        public let data: String?
        public let updateDt: String?
        public let inactive: Bool?
        public let userNick: String?
    }
    
    public struct LikeModel: Codable {
        public let roomID: String?
        public let value: Int?
    }

}

