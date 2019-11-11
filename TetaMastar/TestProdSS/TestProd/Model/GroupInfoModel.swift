//
//  GroupInfoModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 14/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct GroupInfoModel: Decodable {
	
	let result: result?
	
	struct result: Decodable {
		let id: Int?
		let creator: Int?
		let admin: Int?
		let title: String?
		let description: String?
		let parent: Int?
//		let organization: organization?
//		let children: children?
		let createdAt: Int?
		let community: community?
//		let avatarMetaInfo: avatarMetaInfo?
		
		struct community: Decodable {
			let id: Int?
			let members: [members]
			
			struct members: Decodable {
				let id: Int?
				let nickname: String?
			}
		}
	}
	
}
