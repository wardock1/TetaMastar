//
//  GetInfoAboutOrgModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct GetInfoAboutOrg: Decodable {
	
	let result: result
	
	struct result: Decodable {
		let id: Int
		let avatarMetaInfo: avatarMetaInfo
		let date: Int
		let title: String
		let description: String
		let director: Int
		let associatedUsers: associatedUsers
		
		struct associatedUsers: Decodable {
			let id: Int
			let members: [members]
			
			struct members: Decodable {
				let id: Int
				let nickname: String?
				let firstName: String?
				let lastName: String?
				let aboutMe: String?
				let email: String?
				let createdAt: Int
			}
		}
		
		struct avatarMetaInfo: Decodable {
			let id: Int
			let checksum: String
			let size: Int
		}
	}
}
