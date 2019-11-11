//
//  NotificationUserAddedToGroupModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 12/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct NotificationUserAddedToGroupModel: Decodable {
	
	let result: [result]?
	
	struct result: Decodable {
		let data: data?
		let type: String?
		
		struct data: Decodable {
			let id: Int
			let group: group?
			let added: added?
			let addedBy: addedBy?
			
			struct group: Decodable {
				let id: Int?
				let title: String?
			}
			
			struct added: Decodable {
				let id: Int?
				let nickname: String?
			}
			
			struct addedBy: Decodable {
				let id: Int?
				let nickname: String?
			}
		}
	}
	
}

struct NotificationUserAddedToGroupModelInTime: Decodable {
	
	let params: [params]?
	
	struct params: Decodable {
		let data: data?
		let type: String?
		
		struct data: Decodable {
			let id: Int
			let group: group?
			let added: added?
			let addedBy: addedBy?
			
			struct group: Decodable {
				let id: Int?
				let title: String?
			}
			
			struct added: Decodable {
				let id: Int?
				let nickname: String?
			}
			
			struct addedBy: Decodable {
				let id: Int?
				let nickname: String?
			}
		}
	}
	
}
