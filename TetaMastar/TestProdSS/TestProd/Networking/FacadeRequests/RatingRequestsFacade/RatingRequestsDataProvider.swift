//
//  RatingRequestsDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 12/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class RatingRequestsDataProvider {
	
	func requests(type: RatingRequestsType) -> [String: Any] {
		switch type {
		case .isRatingNowInMyGroup:
			return isRatingNowInMyGroup()
			
		case .estimate(let uid, let ratingId,let efficiency, let loyalty, let professionalism, let discipline):
			return estimate(uid: uid, ratingId: ratingId, efficiency: efficiency, loyalty: loyalty, professionalism: professionalism, discipline: discipline)
			
		case .unAnsweredInGroup(let raitingId, let groupId):
			return unAnsweredInGroup(ratingId: raitingId, groupId: groupId)
		}
	}
	
	private func isRatingNowInMyGroup() -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "rating.IsRatingNowInMyGroups",
			"jsonrpc": "2.0",
			"method": "rating.IsRatingNowInMyGroups",
			"params": [
			]
		]
		return parameters
	}
	
	private func estimate(uid: Int, ratingId: Int,efficiency: Int, loyalty: Int, professionalism: Int, discipline: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "rating.Estimate",
			"jsonrpc": "2.0",
			"method": "rating.Estimate",
			"params": [
				"uid": uid,
				"ratingID": ratingId,
				"efficiency": efficiency,
				"loyalty": loyalty,
				"professionalism": professionalism,
				"discipline": discipline
			]
		]
		return parameters
	}
	
	private func unAnsweredInGroup(ratingId: Int, groupId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "rating.UnansweredInGroup",
			"jsonrpc": "2.0",
			"method": "rating.UnansweredInGroup",
			"params": [
				"ratingID": ratingId,
				"gid": groupId
			]
		]
		return parameters
	}
}
