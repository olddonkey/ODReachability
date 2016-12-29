//
//  ViewController.swift
//  ODReachability
//
//  Created by olddonkey on 2016/12/25.
//  Copyright © 2016年 olddonkey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ODReachabilityProtocol {
    
    var delegate: ODReachabilityProtocol?
    var reachability: ODReachability?
    var oldreachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ODReachability.StartODReachabilityWithHostName(hostName: "www.google.com", delegate: self)
//        reachability = Reachability(hostname: "google.com")
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
//        print((reachability?.currentReachabilityString)! as String)
//        
//        do {
//            try reachability?.startNotifier()
//        } catch {
//            print("Can't start Notifier")
//            return
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

