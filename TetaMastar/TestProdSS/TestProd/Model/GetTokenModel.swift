//
//  GetTokenModel.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 26/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct GetTokenModel: Decodable {
	let id: String?
	let result: result?
	
	struct result: Decodable {
		let exp: Int?
		let token: String?
		let userID: Int?
	}
}
