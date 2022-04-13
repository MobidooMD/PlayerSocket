//
//  ViewController.swift
//  PlayerSocket
//
//  Created by keaton on 04/11/2022.
//  Copyright (c) 2022 keaton. All rights reserved.
//

import UIKit
import PlayerSocket


class ViewController: UIViewController {
    @IBOutlet weak var urlInPutTextField: UITextField!
    @IBOutlet weak var roomIdInPutTextField: UITextField!
    @IBOutlet weak var initButton: UIButton!
    @IBOutlet weak var tokenTextField: UITextField!
    var socketConnector: PlayerSocketConnector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 웹 소켓 델리게이트
        PlayerSocketEventCallback.delegate = self
        socketConnector = PlayerSocketConnector()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func initAction(_ sender: Any) {
        var url = String()
        var roomId = String()
        var token = String()
        
        url = urlInPutTextField.text ?? ""
        roomId = roomIdInPutTextField.text ?? ""
        token = tokenTextField.text ?? ""
        
        self.socketConnector?.setConnectionInfo(url: url, isSecure: true, reconnect: true, roomId: roomId, showLog: true)
       
        self.socketConnector?.setUserInfo(isAdmin: true, token: token, userId: "")
        self.onEventRegister()
        self.socketConnector?.socketConnect()
        guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "connectedVC") as? ConnectedVC else { return }
        secondViewController.modalTransitionStyle = .coverVertical
        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.url = urlInPutTextField.text
        secondViewController.roomId = urlInPutTextField.text
        self.present(secondViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: PlayerSocketEventDelegate {
    func onEventRegister() {
        // chat server에서 보내주는 callback event 연결
        socketConnector?.onEventRegister(eventName: "connect", _callback: PlayerSocketEventCallback.onConnect) // 소켓 연결시 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "error", _callback: PlayerSocketEventCallback.error) // 소켓 연결 fail시 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "disconnect", _callback: PlayerSocketEventCallback.onDisconnect) // 소켓 끊어지면 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "statusChange", _callback: PlayerSocketEventCallback.onStatusChange) // 접속상태 업데이트시 들어오는 콜백
        socketConnector?.onEventRegister(eventName: "init", _callback: PlayerSocketEventCallback.onInit) // 초기화 관련 콜백
        socketConnector?.onEventRegister(eventName: "getRoom", _callback: PlayerSocketEventCallback.onGetRoom) // getRoom호출시 콜백 (방정보 획득)
        socketConnector?.onEventRegister(eventName: "getMessages", _callback: PlayerSocketEventCallback.onGetMessages) // 메세지 정보 획득
        socketConnector?.onEventRegister(eventName: "refetchRoom", _callback: PlayerSocketEventCallback.onRefetchRoom) // 방 갱신 이벤트 필요(방정보 전달함)
        // 메세지 관련
        socketConnector?.onEventRegister(eventName: "sendMessage", _callback: PlayerSocketEventCallback.onSendMessage) // 메세지 입력 (모두에게)
        socketConnector?.onEventRegister(eventName: "sendLike", _callback: PlayerSocketEventCallback.onSendLike) // 좋아요 입력 (모두에게)
        socketConnector?.onEventRegister(eventName: "myMessage", _callback: PlayerSocketEventCallback.onMyMessage) // 메세지 입력 (자기자신에게 kinesis를 위해 임시 사용? 서버에서 추가할까 고민중)
        socketConnector?.onEventRegister(eventName: "myLike", _callback: PlayerSocketEventCallback.onMyLike) // 좋아요 입력 (자기자신에게 kinesis를 위해 임시 사용? 서버에서 추가할까 고민중)
        socketConnector?.onEventRegister(eventName: "rejectMessage", _callback: PlayerSocketEventCallback.onRejectMessage) // 메세지 입력시 차단된 경우를 알려주기 위해 (이때는 메세지 입력 콜백이 안온다)
        
        // 구매인증
        socketConnector?.onEventRegister(eventName: "purchaseState", _callback: PlayerSocketEventCallback.onPurchaseState) // 구매 인증 상태 변경(관리자)
        socketConnector?.onEventRegister(eventName: "setPurchase", _callback: PlayerSocketEventCallback.onSetPurchase) // 구매 인증 (사용자)
        socketConnector?.onEventRegister(eventName: "getPurchases", _callback: PlayerSocketEventCallback.onGetPurchases) // 구매인증을 완료한 사용자 리스트 획득
        socketConnector?.onEventRegister(eventName: "winPurchases", _callback: PlayerSocketEventCallback.onWinPurchases)// 구매인증 당첨자 발표때 사용

        // 금칙어, 사용자 차단, 메세지 비활성화 처리
        socketConnector?.onEventRegister(eventName: "updateBannedWord", _callback: PlayerSocketEventCallback.onUpdateBannedWord) // 금칙어 등록/삭제시 사용
        socketConnector?.onEventRegister(eventName: "updateBannedUser", _callback: PlayerSocketEventCallback.onUpdateBannedUser)// 차단사용자 등록/삭제시 사용
        socketConnector?.onEventRegister(eventName: "inactiveMessage", _callback: PlayerSocketEventCallback.onInactiveMessage) // 메세지 비활성화 처리(관리자), 사용자는 inactive 상태 회신받음.
        
        // IP 차단
        socketConnector?.onEventRegister(eventName: "setBanIp", _callback: PlayerSocketEventCallback.onSetBanIp) // 사용자 IP 차단 설정
        socketConnector?.onEventRegister(eventName: "removeBanIp", _callback: PlayerSocketEventCallback.onRemoveBanIp) // 사용자 IP 차단 해제
        socketConnector?.onEventRegister(eventName: "getBanIp", _callback: PlayerSocketEventCallback.onGetBanIp) // IP 차단 리스트 획득
        socketConnector?.onEventRegister(eventName: "rejectIp", _callback: PlayerSocketEventCallback.onRejectIp) // 사용자가 메세지 입력시 차단되었을 경우 알려줌
        
        // 인증정보(토큰)
        socketConnector?.onEventRegister(eventName: "tokenPass", _callback: PlayerSocketEventCallback.onTokenPass) // 토큰 인증 성공
        socketConnector?.onEventRegister(eventName: "invalidToken", _callback: PlayerSocketEventCallback.onInvalidToken) // 토큰 만료와 같은 인증 Fail
    }
    
    func updateConnectionStatus(state: String) {
        print("test1")
        print(state)
    }
    
    func updateMessage(messages: [PlayerSocket.MessageModel]) {
        print("test2")
    }
    
    func updateRoom(updateRoom: PlayerSocket.UpdateRoomModel, isInit: Bool) {
        print("test3")
    }
    
    func refetchRoom(refetchRoom: PlayerSocket.Room, isInit: Bool) {
        print("test4")
    }
    
    func updateInit(initModel: PlayerSocket.InitModel) {
        print("test5")
    }
    
    func chatKinesis(message: PlayerSocket.MessageModel) {
        print("test6")
    }
    
    func likeKinesis(like: PlayerSocket.LikeModel) {
        print("test7")
    }
}
