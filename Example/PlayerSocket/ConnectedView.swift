//
//  connectedView.swift
//  PlayerSocket_Example
//
//  Created by 김원철 on 2022/04/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import PlayerSocket

class ConnectedVC: UIViewController {
   
    @IBOutlet weak var connectState: UILabel!
    @IBOutlet weak var roomIdText: UILabel!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var realTimeUserCount: UILabel!
    @IBOutlet weak var pvCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var chatCount: UILabel!
    @IBOutlet weak var chatState: UILabel!
    @IBOutlet weak var purchaseAuthState: UILabel!
    @IBOutlet weak var purchasePicker: UILabel!
    
    var url = String()
    var token = String()
    var roomId = String()
    
    var socketConnector: PlayerSocketConnector?
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketConnector = PlayerSocketConnector()
        PlayerSocketEventCallback.delegate = self
        
        socketConnector?.setConnectionInfo(url: url, isSecure: true, reconnect: true, roomId: roomId, showLog: true)
        socketConnector?.setUserInfo(isAdmin: true, token: token, userId: "")
        self.onEventRegister()
        socketConnector?.socketConnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func initAction(_ sender: Any) {
        socketConnector?.emitInit()
    }
    @IBAction func connectedAction(_ sender: Any) {
        socketConnector?.socketConnect()
    }
    @IBAction func disConnectAction(_ sender: Any) {
        socketConnector?.socketDisconnect()
    }
}

//MARK allback event 연결
extension ConnectedVC: PlayerSocketEventDelegate {
    func onEventRegister() {
        socketConnector?.onEventRegister(eventName: "connect", _callback: PlayerSocketEventCallback.onConnect) // 소켓 연결시 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "error", _callback: PlayerSocketEventCallback.error) // 소켓 연결 fail시 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "disconnect", _callback: PlayerSocketEventCallback.onDisconnect) // 소켓 끊어지면 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "statusChange", _callback: PlayerSocketEventCallback.onStatusChange) // 접속상태 업데이트시 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "init", _callback: PlayerSocketEventCallback.onInit) // 초기화 관련 콜백
        socketConnector?.onEventRegister(eventName: "getRoom", _callback: PlayerSocketEventCallback.onGetRoom) // getRoom호출시 콜백 (방정보 획득)
    }
    
    func updateConnectionStatus(state: String) {
        connectState.text = state
        switch state {
        case "connect":
            break
        case "error":
            let alert = UIAlertController(title: "ERROR", message: "URL을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let destructiveAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(destructiveAction)
            self.present(alert, animated: false)
            break
        case "stateChage":
            break
        case "disconnect":
            self.pvCount.text = ""
            self.likeCount.text = ""
            chatState.text = ""
            chatCount.text = ""
            realTimeUserCount.text = ""
            purchaseAuthState.text =  ""
            purchasePicker.text = ""
            roomName.text = ""
            roomIdText.text = ""
        default:
            break
        }
    }
    
    func updateMessage(messages: [PlayerSocket.MessageModel]) {
    }
    
    func updateRoom(updateRoom: PlayerSocket.UpdateRoomModel, isInit: Bool) {
        guard let user = updateRoom.joinUser?.first as? PlayerSocket.JoinUser, let room = updateRoom.room as? PlayerSocket.Room else { return }
        
        let viewCount = Int(room.incomingCounterInfo ?? 0)
       
        let countK = viewCount / 1000
        let countKN = (viewCount % 1000) / 100
        if countK > 0 {
            if countK > 999 {
                let countM = countK / 1000
                let countMN = (countK % 1000) / 100
                self.pvCount.text = "\(countM).\(countMN)M"
            } else {
                self.pvCount.text = "\(countK).\(countKN)K"
            }
        } else {
            self.pvCount.text = "\(viewCount)"
        }

        let likeCount = Int(room.reactionCounterInfo ?? 0)
        let likeK = likeCount / 1000
        let likeKN = (likeCount % 1000) / 100
        if likeK > 0 {
            if likeK > 999 {
                let likeM = likeK / 1000
                let likeMM = (likeK % 1000) / 100
                self.likeCount.text = "\(likeM).\(likeMM)M"
            } else {
                self.likeCount.text = "\(likeK).\(likeKN)K"
            }
        } else {
            self.likeCount.text = "\(likeCount)"
        }
        chatState.text = "\(room.canChat)" 
        chatCount.text = "\(room.chatCounterInfo)"
        realTimeUserCount.text = "\(updateRoom.liveUserCount)"
        purchaseAuthState.text =  "\(room.currentPurchase)"
        purchasePicker.text = "\(room.currentWinPurchase)"
        roomName.text = room.title
        roomIdText.text = room.roomId
    }
    
    func refetchRoom(refetchRoom: PlayerSocket.Room, isInit: Bool) {
    }
    
    func updateInit(initModel: PlayerSocket.InitModel) {
        let updateRoomKey = initModel.socketUpdateRoomName!
        socketConnector?.onEventRegister(eventName: updateRoomKey, _callback: PlayerSocketEventCallback.onUpdateRoom)
    }
    
    func chatKinesis(message: PlayerSocket.MessageModel) {
    }
    
    func likeKinesis(like: PlayerSocket.LikeModel) {
    }
    
    func invalidToken() {
        let alert = UIAlertController(title: "유효한 토큰이 아닙니다.", message: "token invalidToken", preferredStyle: UIAlertController.Style.alert)
        let destructiveAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(destructiveAction)
    }
}
