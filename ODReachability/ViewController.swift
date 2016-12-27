//
//  ViewController.swift
//  ODReachability
//
//  Created by olddonkey on 2016/12/25.
//  Copyright © 2016年 olddonkey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let reachability = ODReachability.init(hostName: "www.google.com")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

