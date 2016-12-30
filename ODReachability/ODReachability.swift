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
    fileprivate var notifierRunning: Bool?
    
    class func SetupODReachabilityWithDefaultHostName(delegate: ODReachabilityProtocol) -> ODReachability?{
        
        return ODReachability.SetupODReachabilityWithHostName(hostName: nil, delegate: delegate)
    }
    

    class func SetupODReachabilityWithHostName(hostName: String?, delegate: ODReachabilityProtocol) -> ODReachability?{
        
        let ODReachabilityInstance = ODReachability()
        ODReachabilityInstance.delegate = delegate
        ODReachabilityInstance.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        return ODReachabilityInstance
        
    }
    
    func StartODReachability(){
        
        if notifierRunning == true {return}
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability?.startNotifier()
            notifierRunning = true
        } catch {
            NSLog("Can't start notifier")
            notifierRunning = false
        }
        
    }
    
    func StopODReachability(){
        
        if notifierRunning == false {return}
        reachability?.stopNotifier()
        notifierRunning = false
        NotificationCenter.default.removeObserver(self)
        
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
    
    deinit {
        delegate = nil
        notifierRunning = false
        oldNetWorkStatus = nil
        reachability = nil
    }
}
