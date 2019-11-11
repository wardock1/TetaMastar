//
//  Event.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct Event: Codable {
		let id, creator, group: String?
		let data, condition: Condition?
		let date: Int?
		let closed: Bool?
}
	
	struct Condition: Codable {
}
	

