//
//  ViewController.swift
//  PlayerSocket
//
//  Created by keaton on 04/11/2022.
//  Copyright (c) 2022 keaton. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var urlInPutTextField: UITextField!
    @IBOutlet weak var roomIdInPutTextField: UITextField!
    @IBOutlet weak var initButton: UIButton!
    @IBOutlet weak var tokenTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func initAction(_ sender: Any) {
        var url = String()
        var roomId = String()
        var token = String()
        url = urlInPutTextField.text ?? ""
        roomId = roomIdInPutTextField.text ?? ""
        token = tokenTextField.text ?? ""
        
        if url == "" || roomId == "" || token == "" {
            let alert = UIAlertController(title: "항목을 모두 채워주세요", message: "", preferredStyle: UIAlertController.Style.alert)
            let destructiveAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(destructiveAction)
            self.present(alert, animated: false)
        } else {
            if url.contains("://") == true && url.contains(".") == true {
                guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "connectedVC") as? ConnectedVC else { return }
                secondViewController.modalTransitionStyle = .coverVertical
                secondViewController.modalPresentationStyle = .fullScreen
                
                secondViewController.roomId = roomId
                secondViewController.url = url
                secondViewController.token = token
                
                self.present(secondViewController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "형식에 맞춰써주세요", message: "ex) https://xxxx.com", preferredStyle: UIAlertController.Style.alert)
                let destructiveAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(destructiveAction)
                self.present(alert, animated: false)
            }
        }
    }
    
}
