//
//  GetAboutOrgModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 06/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct GetByAdminOrgModel: Decodable {
	
	let result: result?
	
	struct result: Decodable {
		let director: [director]?
		let linked: [linked]?
		
		struct director: Decodable {
			let id: Int?
			let date: Int?
			let title: String?
			let description: String?
			let director: Int?
			let avatarMetaInfo: avatarMetaInfo?
			let associatedUsers: associatedUsers?
			
			struct associatedUsers: Decodable {
				let id: Int
				let members: [members]?
				
				struct members: Decodable {
					let id: Int?
					let nickname: String?
					let firstName: String?
					let lastName: String?
					let aboutMe: String?
					let email: String?
					let createdAt: Int?
				}
			}
			
			struct avatarMetaInfo: Decodable {
				let id: Int?
				let checksum: String?
			}
		}
		
		struct linked: Decodable {
			let id: Int?
			let date: Int?
			let title: String?
			let description: String?
			let director: Int?
			let nickname: String?
			let avatarMetaInfo: avatarMetaInfo?
			let associatedUsers: associatedUsers?
			
			struct associatedUsers: Decodable {
				let id: Int
				let members: [members]?
				
				struct members: Decodable {
					let id: Int?
					let nickname: String?
					let firstName: String?
					let lastName: String?
					let aboutMe: String?
					let email: String?
					let createdAt: Int?
				}
			}
			
			struct avatarMetaInfo: Decodable {
				let id: Int?
				let checksum: String?
			}
		}
	}
	
}
