//
//  OrgJoinDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 05/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class OrgJoinDataProvider {
	
	func requests(type: OrgJoinRequestsType) -> [String: Any] {
		switch type {
		case .orgStartJoinRequestToOrg(let orgId):
			return orgStartJoinRequestToOrg(orgId: orgId)
			
		case .orgJoinRequestAccept(let requestID, let groupID):
			return orgJoinRequestAccept(requestID: requestID, groupID: groupID)
			
		case .orgJoinRequestDeny(let requestID):
			return orgJoinRequestDeny(requestID: requestID)
			
		case .orgGetAllRequests(let orgId):
			return orgGetAllRequests(orgId: orgId)
		}
		
	}
	
	private func orgJoinRequestAccept(requestID: Int, groupID: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "orgjoinrequest.Accept",
			"jsonrpc": "2.0",
			"method": "orgjoinrequest.Accept",
			"params": [
				"requestID": requestID,
				"groupID": groupID
			]
		]
		return parameters
	}
	
	private func orgJoinRequestDeny(requestID: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "orgjoinrequest.Deny",
			"jsonrpc": "2.0",
			"method": "orgjoinrequest.Deny",
			"params": [
				"requestID": requestID
			]
		]
		return parameters
	}
	
	private func orgGetAllRequests(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "orgjoinrequest.GetByOrg",
			"jsonrpc": "2.0",
			"method": "orgjoinrequest.GetByOrg",
			"params": [
				"requestID": orgId
			]
		]
		return parameters
	}
	
	private func orgStartJoinRequestToOrg(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "orgjoinrequest.Start",
			"jsonrpc": "2.0",
			"method": "orgjoinrequest.Start",
			"params": [
				"oid": orgId
			]
		]
		return parameters
	}
	
}
