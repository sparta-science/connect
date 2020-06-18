//
//  DisconnectViewController.swift
//  SpartaConnect
//
//  Created by mac on 6/17/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

class DisconnectViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func clickDisconnect(sender: NSButton) {
        g_touchVC.setTabIndex(1)
    }
}
