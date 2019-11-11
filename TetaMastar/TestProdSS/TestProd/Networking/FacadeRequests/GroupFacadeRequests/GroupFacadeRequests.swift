//
//  GroupRequestsFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 01/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum GroupTypeRequest {
	case createChildGroupByAdmin(organizationId: Int, parentGroupId: Int, title: String, description: String)
	case createMainGroupByAdmin(organizationId: Int, title: String, description: String)
	case requestToCreateChildGroupByUser(organizationId: Int, parentGroupId: Int, title: String, description: String)
	case getInfo(groupId: Int)
	case getByMember
	case getByOrganization(organizationId: Int)
	case addNewUser(groupId: Int, targetPersonId: Int)
	case groupJoinRequestFromAnotherUser(groupId: Int)
	case leaveGroup(groupId: Int)
	case getAvatar(groupId: Int)
}

enum AnsweringToGroupCreationRequest {
	case confirm(idRequest: Int)
	case deny(idRequest: Int)
}

class GroupFacadeRequests {
	
	private let requestType = GroupFacadeDataProvider()
	
	public func getRequest(typeParams: GroupTypeRequest) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
	public func answerRequest(typeParams: AnsweringToGroupCreationRequest) {
		let typeRequest = requestType.answeringRequest(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
}
