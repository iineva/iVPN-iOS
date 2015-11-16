//
//  ViewController.swift
//  iVPN-iOS
//
//  Created by Steven on 15/11/5.
//  Copyright © 2015年 Neva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let p = NEVPNProtocolIPSec(
        host: "106.187.53.142",
        userName: "AF9E5382-39B7-42E1-BF37-CA2A51526433",
        password: "888888",
        sharedSecret: "xsky")
    
//    let p = NEVPNProtocolIPSec(
//        host: "10.1.1.94",
//        userName: "test",
//        password: "steven",
//        sharedSecret: "steven")
    
    @IBAction func onConnectButtonTouch(sender: AnyObject) {
        
        NEVPNManager.sharedManager().connect("iNeva VPN", protocolConfiguration: p) {
            
            [weak self] (error) -> Void in
            
            if error != nil {
                // TODO 提示错误
                print("连接失败了!!!!: \(error)")
            } else {
                print("已经开始连接")
            }
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

