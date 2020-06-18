//
//  ShowCredentials.swift
//  ConnectCredentials
//
//  Created by Ben Gottlieb on 6/17/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import AppKit


class CredentialsInterface {
	static func showCredentials() {
		guard let url = Bundle.main.url(forAuxiliaryExecutable: "ConnectCredentials.app") else { return }
		
		NSWorkspace.shared.open(url)
	}
}
