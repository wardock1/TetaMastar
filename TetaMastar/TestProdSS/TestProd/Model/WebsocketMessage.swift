//
//  WebsocketMessage.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 30/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
	
	struct Welcome: Codable {
		let data: WelcomeData
		let version: String
	}
	
	struct WelcomeData: Codable {
		let data: DataData
		let date: Int
		let eventType, id: String
	}

	struct DataData: Codable {
		let objectID, objectType: String
	}

struct Invite: Codable {
	let id, initiator, receiver, group: String
	let status, replieadAt: String?
}
	

