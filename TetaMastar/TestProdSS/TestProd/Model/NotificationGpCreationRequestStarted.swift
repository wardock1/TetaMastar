//
//  NotificationGpCreationRequestStarted.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 09/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct NotificationGpCreationRequestStarted: Decodable {
	
	let result: [result]?
	
	struct result: Decodable {
		let data: data?
		let type: String?
		
		struct data: Decodable {
			let id: Int?
//			let initiatorAvatar: initiatorAvatar
//			let parentAvatar: parentAvatar
//			let groupAvatar: groupAvatar
			let request: request?
			
			struct request: Decodable {
				let id: Int?
				let status: String?
				let title: String?
				let description: String?
				let initiator: initiator?
				let parent: parent?
				
				struct parent: Decodable {
					let title: String?
				}
				
				struct initiator: Decodable {
					let id: Int?
					let nickname: String?
				}
			}
			
			struct initiatorAvatar: Decodable {
				let id: Int?
			}
			
			struct parentAvatar: Decodable {
				let id: Int?
			}
			
			struct groupAvatar: Decodable {
				let id: Int?
			}
		}
	}
}
