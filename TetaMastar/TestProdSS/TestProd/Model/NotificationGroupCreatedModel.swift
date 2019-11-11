//
//  NotificationGroupCreatedModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct NotificationGroupCreatedModel: Decodable {
	
	let result: [result]?
	
	struct result: Decodable {
		let data: data
		let type: String
		
		struct data: Decodable {
			let id: Int
			let groupAvatar: groupAvatar?
			let creatorAvatar: creatorAvatar?
			let parentAvatar: parentAvatar?
			let group: group?
			let creator: creator?
			
			struct groupAvatar: Decodable {
//				let id: Int
//				let checksum: String
//				let size: Int
//				let content: String
			}
			
			struct creatorAvatar: Decodable {
//				let id: Int
//				let checksum: String
//				let size: Int
			}
			
			struct parentAvatar: Decodable {
//				let id: Int
//				let checksum: String
//				let size: Int
			}
			
			struct group: Decodable {
				let id: Int
				let creator: Int
				let admin: Int
				let title: String
				let description: String
			}
			
			struct creator: Decodable {
				let id: Int
				let date: Int
				let nickname: String
				let createdAt: Int
				
			}
			
		}
	}
	
}
