//
//  GroupJoinDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class GroupJoinDataProvider {
	
	public func requests(type: GroupTypeJoinRequests) -> [String: Any] {
		switch type {
		case .getAllJoinRequests:
			return getAllJoinRequests()
		case .getAllCreationgGroupRequests:
			return getAllCreationGroupRequests()
		case .acceptJoinRequestToGroup(let requestId):
			return acceptJoinRequestToGroup(requestId: requestId)
		case .denyJoinRequestToGroup(let requestId):
			return denyJoinRequestToGroup(requestId: requestId)
		}
		
	}
	
	private func getAllJoinRequests() -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "groupjoinrequest.GetAll",
			"jsonrpc": "2.0",
			"method": "groupjoinrequest.GetAll",
			"params": [
			]
		]
		return parameters
	}
	private func getAllCreationGroupRequests() -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "groupcreation.GetAll",
			"jsonrpc": "2.0",
			"method": "groupcreation.GetAll",
			"params": [
			]
		]
		return parameters
	}
	
	private func acceptJoinRequestToGroup(requestId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "groupjoinrequest.Accept",
			"jsonrpc": "2.0",
			"method": "groupjoinrequest.Accept",
			"params": [
				"requestID": requestId
			]
		]
		return parameters
	}
	
	private func denyJoinRequestToGroup(requestId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "groupjoinrequest.Deny",
			"jsonrpc": "2.0",
			"method": "groupjoinrequest.Deny",
			"params": [
				"requestID": requestId
			]
		]
		return parameters
	}
	
}
