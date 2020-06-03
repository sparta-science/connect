//
//  AppDelegate.swift
//  SpartaConnect
//
//  Created by Sparta Science on 6/2/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBAction func checkForUpdates(_ sender: Any) {
        let updater = SUUpdater()
        updater.checkForUpdates(sender)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

