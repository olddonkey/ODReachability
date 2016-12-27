//
//  ODReachability.swift
//  ODReachability
//
//  Created by olddonkey on 2016/12/25.
//  Copyright © 2016年 olddonkey. All rights reserved.
//

import Foundation

protocol ODReachabilityProtocol {
    
}

extension ODReachabilityProtocol {
    
}

class ODReachability: NSObject{
    
    var delegate: ODReachabilityProtocol?
    var reachability: Reachability?
    var oldreachability: Reachability?
    
    class func StartODReachabilityWithDefaultHostName(delegate: ODReachabilityProtocol){
        ODReachability.StartODReachabilityWithHostName(hostName: nil, delegate: delegate)
    }
    
    class func StartODReachabilityWithHostName(hostName: String?, delegate: ODReachabilityProtocol){
        print("set up ODReachability with host name: \(hostName)")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(<#T##@objc method#>), name: ReachabilityChangedNotification, object: reachability)
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Can't start Notifier")
            return
        }
    }
    
    public init(hostName: String){
        super.init()
        reachability = Reachability(hostname: hostName)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        print((reachability?.currentReachabilityString)! as String)
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Can't start Notifier")
            return
        }
    }
    
    func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {

        } else {

        }
    }
}
