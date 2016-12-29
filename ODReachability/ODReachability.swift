//
//  ODReachability.swift
//  ODReachability
//
//  Created by olddonkey on 2016/12/25.
//  Copyright © 2016年 olddonkey. All rights reserved.
//

import Foundation

protocol ODReachabilityProtocol {
    func noConnectionToWiFi()
    func noConnectionToWWAN()
    func noConnectionToConnected()
    func WiFiToNoConnection()
    func WiFiToWWAN()
    func WWANToWiFi()
    func WWANToNoConnection()
    func ConnectedToNoConnection()
    
    func ODReachabilitySetup()
}

extension ODReachabilityProtocol {
    func noConnectionToWiFi(){}
    func noConnectionToWWAN(){}
    func noConnectionToConnected(){}
    func WiFiToNoConnection(){}
    func WiFiToWWAN(){}
    func WWANToWiFi(){}
    func WWANToNoConnection(){}
    func ConnectedToNoConnection(){}
    
    func ODReachabilitySetup(){}
}

class ODReachability: NSObject{
    
    var delegate: ODReachabilityProtocol?
    var reachability: Reachability?
    var oldNetWorkStatus: Reachability.NetworkStatus?
    
    class func StartODReachabilityWithDefaultHostName(delegate: ODReachabilityProtocol){
        ODReachability.StartODReachabilityWithHostName(hostName: nil, delegate: delegate)
    }
    
    class func StartODReachabilityWithHostName(hostName: String?, delegate: ODReachabilityProtocol){
        
        let ODReachabilitySingleton = ODReachability()
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        ODReachabilitySingleton.delegate = delegate
        ODReachabilitySingleton.reachability = reachability
        do {
            try reachability?.startNotifier()
        } catch {
            print("Can't start Notifier")
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        print((reachability?.currentReachabilityString)! as String)
    }
    
    
    func reachabilityChanged(_ note: Notification) {
        
        let reachability = note.object as! Reachability

        
        if let oldNetWorkStatus = oldNetWorkStatus {
            switch (oldNetWorkStatus) {
            case .notReachable:
                if reachability.currentReachabilityStatus == .reachableViaWiFi {
                    delegate?.noConnectionToWiFi()
                    delegate?.noConnectionToConnected()
                }else if reachability.currentReachabilityStatus == .reachableViaWWAN {
                    delegate?.noConnectionToWWAN()
                    delegate?.noConnectionToConnected()
                }
            case .reachableViaWiFi:
                if reachability.currentReachabilityStatus == .notReachable{
                    delegate?.WiFiToNoConnection()
                    delegate?.ConnectedToNoConnection()
                }else if reachability.currentReachabilityStatus == .reachableViaWWAN{
                    delegate?.WiFiToWWAN()
                }
            case .reachableViaWWAN:
                if reachability.currentReachabilityStatus == .notReachable {
                    delegate?.WWANToNoConnection()
                    delegate?.ConnectedToNoConnection()
                }else if reachability.currentReachabilityStatus == .reachableViaWiFi{
                    delegate?.WWANToWiFi()
                }
            }
        }else {
            delegate?.ODReachabilitySetup()
        }

        
        oldNetWorkStatus = reachability.currentReachabilityStatus
    }
}
