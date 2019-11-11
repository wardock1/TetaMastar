//
//  NotificationModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct JoinRequestStartedModel: Decodable {
	
	let result: [result]?
	
	struct result: Decodable {
		let data: data
		let type: String
		
		struct data: Decodable {
			let id: Int
			let groupAvatar: groupAvatar?
			var request: request?
			
			
			struct groupAvatar: Decodable {
				let id: Int
				let checksum: String
				let size: Int
//				let content: String
			}
			
			struct request: Decodable {
				let id: Int
				let status: String
				let initiator: initiator
				let group: group?
				
				struct initiator: Decodable {
					let id: Int
					let nickname: String
				}
				
				struct group: Decodable {
					let id: Int
					let creator: Int
					let admin: Int
					let title: String
					let description: String
					
				}
			}
		}
		
	}
	
}
