//
//  MyTouchViewController.swift
//  SpartaConnect
//
//  Created by mac on 6/17/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

class MyTouchViewController: NSTabViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        g_touchVC = self
    }
    
    func setTabIndex(_ index: Int) {
        self.selectedTabViewItemIndex = index
    }
}
