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
    
    var connectStateCheck = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayerSocketEventCallback.delegate = self
        socketConnector?.emitInit()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func initAction(_ sender: Any) {
        if connectStateCheck == "connect" {
            socketConnector?.emitInit()
        }
    }
    @IBAction func connectedAction(_ sender: Any) {
        socketConnector?.socketConnect()
    }
    @IBAction func disConnectAction(_ sender: Any) {
        socketConnector?.socketDisconnect()
    }
}

extension ConnectedVC: PlayerSocketEventDelegate {
    func invalidToken() {
    }
    
    func updateConnectionStatus(state: String) {
        connectStateCheck = state
        connectState.text = state
 
        if state == "disconnect" {
            self.pvCount.text = ""
            self.likeCount.text = ""
            chatState.text = ""
            chatCount.text = ""
            realTimeUserCount.text = ""
            purchaseAuthState.text =  ""
            purchasePicker.text = ""
            roomName.text = ""
            roomIdText.text = ""
        }
    }
    
    func updateMessage(messages: [PlayerSocket.MessageModel]) {
    }
    
    func updateRoom(updateRoom: PlayerSocket.UpdateRoomModel, isInit: Bool) {
        if let user = updateRoom.joinUser?.first as? PlayerSocket.JoinUser {
            print(user)
        }
        guard let room = updateRoom.room as? PlayerSocket.Room else {
           return
        }
        connectState.text = "connect"
        // 뷰 카운트
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

        // 좋아요
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
}
