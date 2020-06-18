//
//  CredentialsWindow.swift
//  ConnectCredentials
//
//  Created by Ben Gottlieb on 6/17/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import Cocoa

class CredentialsWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
	
	@IBAction func okCLicked(_ sender: Any?) {
		NSApp.terminate(nil)
	}
    
}
