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

    fileprivate var reachability: Reachability?
    fileprivate var oldNetWorkStatus: Reachability.NetworkStatus?
    
    class func StartODReachabilityWithDefaultHostName(delegate: ODReachabilityProtocol) -> ODReachability?{
        return ODReachability.StartODReachabilityWithHostName(hostName: nil, delegate: delegate)
    }
    

    class func StartODReachabilityWithHostName(hostName: String?, delegate: ODReachabilityProtocol) -> ODReachability?{
        
        let ODReachabilitySingleton = ODReachability()
        ODReachabilitySingleton.delegate = delegate
        ODReachabilitySingleton.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        do {
            try ODReachabilitySingleton.reachability?.startNotifier()
        } catch {
            print("Can't start Notifier")
        }
        NotificationCenter.default.addObserver(ODReachabilitySingleton, selector: #selector(ODReachabilitySingleton.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: ODReachabilitySingleton.reachability)
        print((ODReachabilitySingleton.reachability?.currentReachabilityString)! as String)
        return ODReachabilitySingleton
    }
    
    func StopODReachability(){
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
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
