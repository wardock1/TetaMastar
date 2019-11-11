//
//  RatingInMyGroupModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 12/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct RatingInMyGroupModel: Decodable {
	
	let result: [result]
	
	struct result: Decodable {
		let id: Int?
		let start: Int?
		let end: Int?
		let organization: organization?
		
		struct organization: Decodable {
			let id: Int?
			let title: String?
			let description: String?
		}
	}
	
}

struct RatingAnswerOkResponse: Decodable {
	let result: result?
	
	struct result: Decodable {
		let message: String?
	}
}
