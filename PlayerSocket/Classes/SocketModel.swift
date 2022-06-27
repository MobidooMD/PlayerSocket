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
        public let userId : String?
        public func socketRepresentation() -> SocketData {
            return ["isAdmin": isAdmin ?? false, "token": token ?? "", "userId": userId ?? ""]
        }
    }

    // socket emit init 요청에 대한 구조체
    public struct Init: SocketData {
        public let roomId : String?
        public let auth : Auth?
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId, "auth": auth?.socketRepresentation()]
        }
    }
    
    // socket emit sendMessage에 대한 구조체
    public struct sendMessage: SocketData {
        public let roomId: String?
        public let isAdmin: Bool?
        public let messageInput: MessageInput?
        
        public init(roomId: String, isAdmin: Bool, messageInput: MessageInput) {
            self.roomId = roomId
            self.isAdmin = isAdmin
            self.messageInput = messageInput
        }
        
        public struct MessageInput {
            public let partnerId: String?
            public let messageType: Int?
            public let message: String?
            public let userNick: String?
            public let isLive: Bool?
            public let userName: String?
            public let userId: String?
            public let roomId: String?
            public var data = "none"
            
            public init(partnerId: String, messageType: Int, message: String, userNick: String, isLive: Bool, userName: String, userId: String, roomId: String, data:String = "none") {
                self.partnerId = partnerId
                self.messageType = messageType
                self.message = message
                self.userNick = userNick
                self.isLive = isLive
                self.userName = userName
                self.userId = userId
                self.roomId = roomId
                self.data = data
              }
            
            public func socketRepresentation() -> SocketData {
                return ["partnerId": partnerId ?? "", "messageType": messageType ?? 0, "message": message ?? "", "userNick": userNick ?? "", "isLive": isLive ?? false, "userName": userName ?? "", "userId": userId ?? "", "roomId": roomId ?? "", "data": data]
            }
        }
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId, "isAdmin": isAdmin, "input": messageInput?.socketRepresentation()]
        }
    }
    
    // socket emit sendLike 요청에 대한 구조체
    public struct sendLike: SocketData {
        public let roomId : String?
        
        public init(roomId: String) {
            self.roomId = roomId
        }
        
        public func socketRepresentation() -> SocketData {
            return ["roomId": roomId ?? "", "value": 1]
        }
    }
    
    

    // MARK: - Response | Codable
    public struct BanUserInfo : Codable {
        public var userId : [String]?
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
        public var isLive : Bool?
        public var message : String?
        public var messageId : String?
        public var messageType : Int?
        public var partnerId : String?
        public var regDate : String?
        public var roomId : String?
        public var userId : String?
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
        public var roomId : String?
    }

    public struct MessageModel: Codable {
        public let regDate: String?
        public let isAdmin: Bool?
        public let message: String?
        public let messageId: String?
        public let partnerId: String?
        public let messageType: Int?
        public let deleteOwner: String?
        public let isLive: Bool?
        public let roomId: String?
        public let userId: String?
        public let userName: String?
        public let data: String?
        public let updateDt: String?
        public let inactive: Bool?
        public let userNick: String?
    }
    
    public struct LikeModel: Codable {
        public let roomId: String?
        public let value: Int?
    }

}

