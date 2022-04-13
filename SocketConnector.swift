//
//  SocketConnector.swift
//  PlayerSocket
//
//  Created by 김원철 on 2022/04/13.
//

import Foundation
import SocketIO

public class PlayerSocketConnector {
    
    public init() {
    }
    
    var manager : SocketManager?
    var socket : SocketIOClient?
    var _url : String?
    var _isSecure : Bool = true
    var _reconnect : Bool = true
    var _roomId : String?
    var _isAdmin : Bool = false
    var _token : String?
    var _userId : String?
    
    public func setConnectionInfo(url : String, isSecure : Bool, reconnect : Bool, roomId : String, showLog : Bool) {
        _url = url
        _isSecure = isSecure
        _reconnect = reconnect
        _roomId = roomId
        
        manager = SocketManager(
            socketURL: URL(string: _url ?? "")!,
            config: [
                .log(showLog),
                .secure(_isSecure),
                .forceWebsockets(true),
                .reconnects(_reconnect)
            ])
        
        socket = manager?.defaultSocket
    }
    
    public func setUserInfo(isAdmin: Bool, token: String, userId: String) {
        _isAdmin = isAdmin
        _token = token
        _userId = userId
    }
    
    public func onEventRegister(eventName: String, _callback: @escaping ([Any], SocketAckEmitter) -> ()) {
        guard let socket = socket else { return }
        socket.on(eventName, callback: _callback)
    }
    
    public func socketConnect() {
        guard let socket = socket else { return }
        LogManager.print(output: "CONNECTOR try connect", logType: .WebSocket)
        socket.connect()
    }
    
    public func socketDisconnect() {
        guard let socket = socket else { return }
        LogManager.print(output: "CONNECTOR try disconnect", logType: .WebSocket)
        socket.disconnect()
    }
    
    public func emitInit() {
        LogManager.print(output: "CONNECTOR emitInit", logType: .WebSocket)
        guard let roomId = _roomId, let token = _token, let userId = _userId , let socket = socket else { return }
        
        let initModel: PlayerSocket.Init = PlayerSocket.Init(roomId: roomId, auth: PlayerSocket.Auth(isAdmin: _isAdmin, token: token, userId: userId))
        socket.emit("init", initModel)
    }
    
    public func sendMessage(with model: PlayerSocket.sendMessage) {
        LogManager.print(output: "CONNECTOR sendMessage", logType: .WebSocket)
        guard let socket = socket else { return }
        socket.emit("sendMessage", model)
    }
    
    public func sendLike(with roomId: String) {
        LogManager.print(output: "CONNECTOR sendLike", logType: .WebSocket)
        
        guard let socket = socket else { return }
        let model = PlayerSocket.sendLike(roomId: roomId)
        socket.emit("sendLike", model)
    }
    
}
