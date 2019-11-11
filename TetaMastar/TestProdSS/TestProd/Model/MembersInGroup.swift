//
//  MembersInGroup.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 29/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import UIKit

struct MembersInGroup {
	
	var memberId: String
	var uid: Int?
	var name: String?
	var secondName: String?
	var age: Int?
	var avatar: UIImage?
	
}

struct modelMembersInGroup: Decodable {
	
	let jsonrpc: String
	let result: result
	
	struct result: Decodable {
		let community: community
		
		struct community: Decodable {
			let id: Int
			let members: [members]
			
			struct members: Decodable {
					let id: Int?
					let teel: Int?
					let experience: Int?
					let date: Int?
					let nickname: String
					let firstName: String?
					let lastName: String?
					let createdAt: Int?
					let avatarMetaInfo: avatarMetaInfo?
					let score: score
				
				struct avatarMetaInfo: Decodable {
					let id: Int?
					let checksum: String?
					
				}
				
				struct score: Decodable {
					let efficiency: Int
					let loyalty: Int
					let professionalism: Int
					let discipline: Int
					let rang: String
				}
			}
		}
	}
}

struct NewMembersInGroup: Decodable {
	
	let jsonrpc: String
	let result: result
	
	struct result: Decodable {
		
		let id: Int
		let creator: Int
		let admin: Int
		let title: String
		let description: String
		let organization: organization
		let children: children
		let createdAt: Int
		let community: community
		let avatarMetaInfo: avatarMetaInfo
		
		
		
		struct community: Decodable {
			let id: Int
			let members: members
			
			struct members: Decodable {
				struct members: Decodable {
					let id: Int
					let teel: Int
					let experience: Int
					let date: Int
					let nickname: String
					let createdAt: Data
					let score: score
				}
				struct score: Decodable {
					let efficiency: Int
					let loyalty: Int
					let professionalism: Int
					let discipline: Int
					let rang: String
				}
			}
		}
		
		struct organization: Decodable {
			let id: Int
			let date: Int
			let title: String
			let description: String
			let director: Int
			let nickname: String
			let associatedUsers: associatedUsers
			//	let fns: JSONNull
			
			struct associatedUsers: Decodable {
				let id: Int
				let members: [members]
			}
			
			struct members: Decodable {
				struct members: Decodable {
					let id: Int
					let teel: Int
					let experience: Int
					let date: Int
					let score: score
					let nickname: String
					let createdAt: Int
				}
				struct score: Decodable {
					let efficiency: Int
					let loyalty: Int
					let professionalism: Int
					let discipline: Int
					let rang: String
				}
			}
			
		}
		
		struct children: Decodable {
			
		}
		struct avatarMetaInfo: Decodable {
			
		}
		
	}

}
