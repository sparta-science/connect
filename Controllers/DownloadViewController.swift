//
//  DownloadViewController.swift
//  SpartaConnect
//
//  Created by mac on 6/17/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

class DownloadViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func clickCancel(sender: NSButton) {
        g_touchVC.setTabIndex(0)
    }
    
    @IBAction func clickDownload(sender: NSButton) {
        g_touchVC.setTabIndex(2)
    }
}
