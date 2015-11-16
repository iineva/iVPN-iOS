//
//  VPNHelper.swift
//  VPNTest
//
//  Created by Steven on 15/9/29.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Foundation
import NetworkExtension

@available(iOS 8.0, *)
extension NEVPNManager {
    
    /**
    连接一个VPN
    
    - parameter localizedDescription: VPN连接的标题
    - parameter protocolObject:       VPN连接配置
    - parameter complete:             完成回调
    */
    @available(iOS 8.0, *)
    func connect(localizedDescription: String?, protocolConfiguration: NEVPNProtocol, complete: (error: NEVPNError?) -> Void ) {
        
        self.loadFromPreferencesWithCompletionHandler {
            [weak self](error: NSError?) -> Void in
            
            if error != nil {
                print("Load error: \(error)");
                complete(error: NEVPNError.ConfigurationReadWriteFailed)
            } else {
                
                self?.`protocol` = protocolConfiguration
                self?.localizedDescription = localizedDescription
                self?.enabled = true
                self?.onDemandEnabled = false // 按需启动
                
                // 设置连接规则
                var  rules = [NEOnDemandRuleConnect]()
                
                // 允许使用wifi数据流量
                let rule1 = NEOnDemandRuleConnect();
                rule1.interfaceTypeMatch = NEOnDemandRuleInterfaceType.WiFi
                rules.append(rule1)
                
                // 允许使用蜂窝移动数据流量
                let rule2 = NEOnDemandRuleConnect();
                rule2.interfaceTypeMatch = NEOnDemandRuleInterfaceType.Cellular
                rules.append(rule2)
                
                self?.onDemandRules = rules
                
                // 保存配置到系统，会提示用户，跳转到设置页确认
                self?.saveToPreferencesWithCompletionHandler({ (e: NSError?) -> Void in
                    // 保存后回调
                    if error != nil {
                        print("Save Error: \(e)")
                        complete(error: NEVPNError.ConfigurationReadWriteFailed)
                    } else {
                        print("Saved!")
                        print("Connect Start...")
                        do {
                            try self?.connection.startVPNTunnel()
                            print("Connect Started!!")
                            complete(error: nil)
                        } catch {
                            print("Connect Error: \(error)")
                            complete(error: NEVPNError.ConnectionFailed)
                        }
                    }
                })
            }
        }
    }
}

let kUserPassword = "user_pwd"
let kSharedSecret = "SharedSecret"

extension NEVPNProtocolIPSec {
    
    public convenience init(host: String, userName user: String, password: String, sharedSecret: String, localIdentifier: String? = nil, remoteIdentifier: String? = nil ) {
        
        self.init()
        
        VPNDemand.storeString(password, key: kUserPassword)
        VPNDemand.storeString(sharedSecret, key: kSharedSecret)
        
        self.username               = user
        self.passwordReference      = VPNDemand.getDataWithKey(kUserPassword)
        self.serverAddress          = host
        self.authenticationMethod   = NEVPNIKEAuthenticationMethod.SharedSecret
        self.sharedSecretReference  = VPNDemand.getDataWithKey(kSharedSecret)
        self.localIdentifier        = nil//localIdentifier ?? "vpn"
        self.remoteIdentifier       = nil//remoteIdentifier ?? "vpn"
        self.useExtendedAuthentication = true
        self.disconnectOnSleep      = false
    }
}
