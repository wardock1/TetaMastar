//
//  OrgJoinRequestsFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 05/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum OrgJoinRequestsType {
	case orgJoinRequestAccept(requestID: Int, groupID: Int)
	case orgJoinRequestDeny(requestID: Int)
	case orgGetAllRequests(orgId: Int)
	case orgStartJoinRequestToOrg(orgId: Int)
}

class OrgJoinRequestsFacade {
	
	private let requestType = OrgJoinDataProvider()
	
	public func getRequest(typeParams: OrgJoinRequestsType) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
}
