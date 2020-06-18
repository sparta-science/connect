//
//  AppDelegate.swift
//  ConnectCredentials
//
//  Created by Ben Gottlieb on 6/17/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let credentialsWindow = CredentialsWindow(windowNibName: NSNib.Name("CredentialsWindow"))

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		self.credentialsWindow.showWindow(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

