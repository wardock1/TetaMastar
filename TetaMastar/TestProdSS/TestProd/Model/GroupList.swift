//
//  GroupList.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import UIKit

struct GroupList {
	
	var name: String
	var description: String?
	var id: String?
	var creator: String?
	var admin: String?
	var status: String?
	var date: String?
	var avatar: UIImage?
	var statusBar: UIImage?
	var nextButton: UIImage?
	var membersInGroup: MembersInGroup?
	
}

struct NodeData {
	
	var parent: String?
	var organization: String?
	var children: Children
	
	init(parent: String?, organization: String?, children: Children) {
		self.parent = parent
		self.organization = organization
		self.children = children
	}
	
	struct Children {
		var id: String?
		
		init(id: String?) {
			self.id = id
		}
	}
}


struct NewGroupList: Decodable {
	
	let jsonrpc: String
	let result: [result]
	
	struct result: Decodable {
		let id: Int
		let creator: Int
		let admin: Int
		let title: String
		let description: String
		let organization: organization
		let children: [Int]
		let createdAt: Int
		let community: community
		let avatarMetaInfo: avatarMetaInfo
		
		struct avatarMetaInfo: Decodable {
			let id: Int
			let checksum: String
			let size: Int
		}
		
		struct organization: Decodable {
			let id: Int
			let date: Int
			let title: String
			let description: String
			let director: Int
			let nickname: String
			let associatedUsers: associatedUsers
			let fns: JSONNull
			
			struct associatedUsers: Decodable {
				let id: Int
				let members: members
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
	}
	
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
				let createdAt: Int
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
	
	class JSONNull: Codable, Hashable {
		
		public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
			return true
		}
		
		public var hashValue: Int {
			return 0
		}
		
		public init() {}
		
		public required init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			if !container.decodeNil() {
				throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.singleValueContainer()
			try container.encodeNil()
		}
		
	}
}


struct SingleGroupInfo: Decodable {
	
	let jsonrpc: String
	let result: result
	
	struct result: Decodable {
		let id: Int
		let creator: Int
		let admin: Int
		let title: String
		let description: String
		let organization: organization
		let children: [Int]
		let createdAt: Int
		let community: community
		
		struct organization: Decodable {
			let id: Int
			let date: Int
			let title: String
			let description: String
			let director: Int
			let nickname: String
			let associatedUsers: associatedUsers
			
			struct associatedUsers: Decodable {
				let id: Int
				let members: members
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
	}
	
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
				let createdAt: Int
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
}



struct NewGroupListWithAvatar  {
	
	let jsonrpc: String
	let result: [result]
	
	struct result  {
		let id: Int
		let creator: Int
		let admin: Int
		let title: String
		let description: String
		let children: [Int]
		let createdAt: Int
		let avatarMetaInfo: avatarMetaInfo
		
		struct avatarMetaInfo  {
			let id: Int
			let checksum: String
			let size: Int
			let avatar: UIImage
		}
	}
}



struct NewGroupListWithAvatar1 {
	
	let jsonrpc: String
	let result: [result]
	
	struct result {
		let id: Int
		let creator: Int
		let admin: Int
		let title: String
		let description: String
		let organization: organization
		let children: [Int]
		let createdAt: Int
//		let community: community
		let avatarMetaInfo: avatarMetaInfo
		
		struct avatarMetaInfo {
			let id: Int
			let checksum: String
			let size: Int
			let avatar: UIImage
		}
		
		struct organization {
			let id: Int
			let date: Int
			let title: String
			let description: String
			let director: Int
			let nickname: String
			
			struct associatedUsers {
				let id: Int
//				let members: members
			}
			
			struct members {
				struct members {
					let id: Int
					let teel: Int
					let experience: Int
					let date: Int
					let score: score
					let nickname: String
					let createdAt: Int
				}
				struct score {
					let efficiency: Int
					let loyalty: Int
					let professionalism: Int
					let discipline: Int
					let rang: String
				}
			}
			
		}
	}
	
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
				let createdAt: Int
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
	
	class JSONNull: Codable, Hashable {
		
		public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
			return true
		}
		
		public var hashValue: Int {
			return 0
		}
		
		public init() {}
		
		public required init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			if !container.decodeNil() {
				throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.singleValueContainer()
			try container.encodeNil()
		}
		
	}
}
