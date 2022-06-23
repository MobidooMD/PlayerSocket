import Foundation
import SocketIO
import SauceLog

typealias LogManager = SauceLog

public protocol PlayerSocketEventDelegate: class {
    func onEventRegister()
    func updateConnectionStatus(state : String)
    func updateMessage(messages: [PlayerSocket.MessageModel])
    func updateRoom(updateRoom: PlayerSocket.UpdateRoomModel, isInit: Bool)
    func refetchRoom(refetchRoom: PlayerSocket.Room, isInit: Bool)
    func updateInit(initModel: PlayerSocket.InitModel)
    func invalidToken()
    
    // Kinesis Delegate
    func chatKinesis(message: PlayerSocket.MessageModel)
    func likeKinesis(like: PlayerSocket.LikeModel)
}

public class PlayerSocketEventCallback {
    public weak static var delegate: PlayerSocketEventDelegate?
    
    static public func onConnect (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "connect", logType: .Network)
        delegate?.updateConnectionStatus(state: "connect")
    }
    
    static public func onDisconnect (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "disconnect", logType: .Network)
        delegate?.updateConnectionStatus(state: "disconnect")
    }
    
    static public func error (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "error", logType: .Network)
        delegate?.updateConnectionStatus(state: "error")
    }
    
    static public func onStatusChange (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "statusChange \(data)", logType: .Network)
        delegate?.updateConnectionStatus(state: "statusChange")
        
    }
    
    static public func onInit (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "*********************************************** init", logType: .Network)
        
        guard let response = data.first else { return }
        
        let responseJson = try? JSONSerialization.data(withJSONObject: response, options: [])
        
        if let obj = try? JSONDecoder().decode(PlayerSocket.InitModel.self, from: responseJson!) {
            delegate?.updateInit(initModel: obj)
            let model = PlayerSocket.UpdateRoomModel(joinUser: obj.joinUser, liveUserCount: obj.liveUserCount, room: obj.room, roomId: obj.room?.roomId)
            delegate?.updateRoom(updateRoom: model, isInit: true)
        }
    }
    
    static public func onGetRoom (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "*********************************************** getRoom", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onUpdateRoom (data: [Any], ack : SocketAckEmitter) {
         LogManager.print(output: "*********************************************** updateRoom", logType: .Network)
        guard let response = data.first else { return }
        let responseJson = try? JSONSerialization.data(withJSONObject: response, options: [])
        
        if let obj = try? JSONDecoder().decode(PlayerSocket.UpdateRoomModel.self, from: responseJson!) {
            delegate?.updateRoom(updateRoom: obj, isInit: false)
        }
    }
    
    static public func onGetMessages (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "*********************************************** getMessages", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onRejectMessage (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "*********************************************** rejectMessage", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onRefetchRoom (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "refetchRoom", logType: .Network)
        LogManager.print(output: data, logType: .Network)
        guard let response = data.first else { return }
        let responseJson = try? JSONSerialization.data(withJSONObject: response, options: [])
        
        if let obj = try? JSONDecoder().decode(PlayerSocket.Room.self, from: responseJson!) {
            delegate?.refetchRoom(refetchRoom: obj, isInit: false)
        }
    }
    
    static public func onSendMessage (data: [Any], ack : SocketAckEmitter) {
        
        var messageList: [PlayerSocket.MessageModel] = []
        
        guard let response = data.first as? NSMutableArray else { return }
        
        response.forEach { inside in
            
            let responseJson = try? JSONSerialization.data(withJSONObject: inside, options: [])
            
            if let obj = try? JSONDecoder().decode(PlayerSocket.MessageModel.self, from: responseJson!) {
                guard let message = obj as? PlayerSocket.MessageModel else { return }
                messageList.append(message)
            }
        }
        
        delegate?.updateMessage(messages: messageList)
    }
    
    static public func onSendLike (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "sendLike", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onMyMessage (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "*********************************************** myMessage", logType: .Network)
        
        guard let response = data.first as? NSMutableArray else { return }
        
        response.forEach { inside in
            
            let responseJson = try? JSONSerialization.data(withJSONObject: inside, options: [])
            
            if let obj = try? JSONDecoder().decode(PlayerSocket.MessageModel.self, from: responseJson!) {
                guard let message = obj as? PlayerSocket.MessageModel else { return }
                
               // LogManager.print(output: "MyMessage 111 *********** \(message)", logType: .Kinesis)
                
                delegate?.chatKinesis(message: message)
            }
        }
    }
    
    static public func onMyLike (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "*********************************************** myLike : \(data.first)", logType: .Network)
        
        guard let response = data.first else { return }
        
        let responseJson = try? JSONSerialization.data(withJSONObject: response, options: [])

        if let obj = try? JSONDecoder().decode(PlayerSocket.LikeModel.self, from: responseJson!) {
            
            guard let like = obj as? PlayerSocket.LikeModel else { return }
            
            LogManager.print(output: "MyLike 222 *** \(like)", logType: .Network)
            delegate?.likeKinesis(like: like)
        }
    }
    
    static public func onPurchaseState (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "purchaseState", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onSetPurchase (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "setPurchase", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onGetPurchases (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "getPurchases", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onWinPurchases (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "winPurchases", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onUpdateBannedWord (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "updateBannedWord", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onUpdateBannedUser (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "updateBannedUser", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onInactiveMessage (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "inactiveMessage", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onSetBanIp (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "setBanIp", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onRemoveBanIp (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "removeBanIp", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onGetBanIp (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "getBanIp", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onRejectIp (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "rejectIp", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onTokenPass (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "tokenPass", logType: .Network)
        LogManager.print(output: data, logType: .Network)
    }
    
    static public func onInvalidToken (data: [Any], ack : SocketAckEmitter) {
        LogManager.print(output: "invalidToken", logType: .Network)
        LogManager.print(output: data, logType: .Network)
        delegate?.invalidToken()
    }
}
