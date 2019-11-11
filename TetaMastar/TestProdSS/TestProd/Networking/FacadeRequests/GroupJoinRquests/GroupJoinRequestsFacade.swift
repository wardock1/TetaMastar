//
//  GroupJoinRequestsFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum GroupTypeJoinRequests {
	case getAllJoinRequests
	case getAllCreationgGroupRequests
	case acceptJoinRequestToGroup(requestId: Int)
	case denyJoinRequestToGroup(requestId: Int)
}

class GroupJoinRequestsFacade {
	
	private let requestType = GroupJoinDataProvider()
	
	public func getRequest(typeParams: GroupTypeJoinRequests) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
}
