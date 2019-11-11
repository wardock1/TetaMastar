//
//  NotificationGroupCreatedRequestDenied.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 11/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct NotificationGroupCreatedRequestDeniedAccepted: Decodable {
	
	let result: [result]?
	
	struct result: Decodable {
		let data: data?
		let type: String?
		
		
		struct data: Decodable {
			let id: Int?
			let request: request?
			
			struct request: Decodable {
				let id: Int?
				let status: String?
				let title: String?
				let description: String?
				let initiator: initiator?
				let parent: parent?
				
				struct initiator: Decodable {
					let id: Int?
					let nickname: String?
				}
				
				struct parent: Decodable {
					let id: Int?
					let title: String?
					let description: String?
					let parent: Int?
					let createdAt: Int?
				}
		}
	}
	}
}

struct NotificationGroupCreatedRequestAccepted: Decodable {
	
	let result: [result]?
	
	struct result: Decodable {
		let data: data?
		let type: String?
		
		
		struct data: Decodable {
			let id: Int?
			let request: request?
			
			struct request: Decodable {
				let id: Int?
				let status: String?
				let title: String?
				let description: String?
				let initiator: initiator?
				let parent: parent?
				
				struct initiator: Decodable {
					let id: Int?
					let nickname: String?
				}
				
				struct parent: Decodable {
					let id: Int?
					let title: String?
					let description: String?
					let parent: Int?
					let createdAt: Int?
				}
			}
		}
	}
}
