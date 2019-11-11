//
//  User.swift
//  TestProd
//
//  Created by Developer on 16/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    var id: String?
	var uid: Int?
    var name: String?
    var secondName: String?
	var phone: String?
    var age: Int?
    var avatar: UIImage?
	var date: String?
    
}

struct Authentification {
    
    var expired: String
    var id: String
    var token: String
    
}

struct NewUser: Decodable {
	
	let result: result
	
	struct result: Decodable {
		let id: Int?
		let phone: String?
		let teel: Int?
		let experience: Int?
		let date: Int?
		let score: score?
		let nickname: String?
		let createdAt: Int?
		
		let firstName: String?
		let lastName: String?
		let aboutMe: String?
		let email: String?
		
		struct score: Decodable {
			let efficiency: Int?
			let loyalty: Int?
			let professionalism: Int?
			let discipline: Int?
			let rang: String?
		}
	}
}

struct FindedUsers: Decodable {
	
	let result: [result]
	
	struct result: Decodable {
		let id: Int?
		let phone: String?
		let teel: Int?
		let experience: Int?
		let date: Int?
		let score: score?
		let nickname: String?
		let createdAt: Int?
		
		let firstName: String?
		let lastName: String?
		let aboutMe: String?
		let email: String?
		
		struct score: Decodable {
			let efficiency: Int?
			let loyalty: Int?
			let professionalism: Int?
			let discipline: Int?
			let rang: String?
		}
	}
}

struct UnAnsweredUsers: Decodable {
	
	let result: [result]
	
	struct result: Decodable {
		let id: Int?
		let phone: String?
		let teel: Int?
		let experience: Int?
		let date: Int?
		let score: score?
		let nickname: String?
		let createdAt: Int?
		
		struct score: Decodable {
			let efficiency: Int?
			let loyalty: Int?
			let professionalism: Int?
			let discipline: Int?
			let rang: String?
		}
	}
}
