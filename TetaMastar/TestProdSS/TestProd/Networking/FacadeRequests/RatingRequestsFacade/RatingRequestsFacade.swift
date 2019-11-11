//
//  RatingRequestsFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 12/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum RatingRequestsType {
	case isRatingNowInMyGroup
	case estimate(uid: Int, ratingId: Int,efficiency: Int, loyalty: Int, professionalism: Int, discipline: Int)
	case unAnsweredInGroup(raitingId: Int, groupId: Int)
}

class RatingRequestsFacade {
	private let requestType = RatingRequestsDataProvider()
	
	public func getRequest(typeParams: RatingRequestsType) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
}
