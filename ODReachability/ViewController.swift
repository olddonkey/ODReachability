//
//  ViewController.swift
//  ODReachability
//
//  Created by olddonkey on 2016/12/25.
//  Copyright © 2016年 olddonkey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ODReachabilityProtocol {
    
    var reachability: ODReachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reachability = ODReachability.SetupODReachabilityWithHostName(hostName: "www.google.com", delegate: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func WiFiToNoConnection() {
        print("No Network")
    }
    
    func WiFiToWWAN() {
        print("WiFi change to WWAN")
    }

    @IBAction func startODReachability(_ sender: Any) {
        reachability?.StartODReachability()
    }

    @IBAction func StopODReachability(_ sender: Any) {
        reachability?.StopODReachability()
    }
}

