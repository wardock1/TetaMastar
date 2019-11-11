//
//  UserRating.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

struct UserRating: Codable {
	
	var discipline: Int?
	var efficiency: Int?
	var loyalty: Int?
	var professionalism: Int?
	
	init(discipline: Int?, efficiency: Int?, loyalty: Int?, professionalism: Int?) {
		self.discipline = discipline
		self.efficiency = efficiency
		self.loyalty = loyalty
		self.professionalism = professionalism
	}
	
}
