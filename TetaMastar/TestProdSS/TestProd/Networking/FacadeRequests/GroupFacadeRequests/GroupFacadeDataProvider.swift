//
//  GroupFacadeDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 01/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Locksmith

class GroupFacadeDataProvider {
	
	public func requests(type: GroupTypeRequest) -> [String: Any] {
		switch type {
		case .addNewUser(let groupId, let targetPersonId):
			return addNewUser(groupId: groupId, targetPersonId: targetPersonId)
			
		case .createChildGroupByAdmin(let organizationId, let parentGroupId, let title, let description):
			return createChildGroupByAdmin(organizationId: organizationId, parentGroupId: parentGroupId, title: title, description: description)
			
		case .createMainGroupByAdmin(let organizationId, let title, let description):
			return createMainGroupByAdmin(organizationId: organizationId, title: title, description: description)
			
		case .requestToCreateChildGroupByUser(let organizationId, let parentGroupId, let title, let description):
			return requestToCreateChildGroupByUser(organizationId: organizationId, parentGroup: parentGroupId, title: title, description: description)
			
		case .getByMember:
			return getByMember()
		case .getByOrganization(let organizationId):
			return getByOrganization(organizationId: organizationId)
			
		case .getInfo(let groupId):
			return getInfo(groupId: groupId)
			
		case .groupJoinRequestFromAnotherUser(let groupId):
			return groupJoinRequestFromAnotherUser(groupId: groupId)
			
		case .leaveGroup(let groupId):
			return leaveGroup(groupId: groupId)
			
		case .getAvatar(let groupId):
			return getAvatar(groupId: groupId)
		}
		
	}
	
	public func answeringRequest(type: AnsweringToGroupCreationRequest) -> [String: Any] {
		switch type {
		case .confirm(let idRequest):
			return confirmGroupCreationRequest(idRequest: idRequest)
			
		case .deny(let idRequest):
			return denyGroupCreationRequest(idRequest: idRequest)
		}
	}
	
	
	private func addNewUser(groupId: Int, targetPersonId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "group.AddUser",
			"jsonrpc": "2.0",
			"method": "group.AddUser",
			"params": [
				"gid": groupId,
				"targetPerson": targetPersonId
			]
		]
		return parameters
	}
	
	private func createChildGroupByAdmin(organizationId: Int, parentGroupId: Int, title: String, description: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "1 group.Create",
			"jsonrpc": "2.0",
			"method": "group.Create",
			"params": [
				"oid": organizationId,
				"nickname": title,
				"parent": parentGroupId,
				"title": title,
				"description": description,
			]
		]
		return parameters
	}
	
	private func createMainGroupByAdmin(organizationId: Int, title: String, description: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "1 group.Create",
			"jsonrpc": "2.0",
			"method": "group.Create",
			"params": [
				"oid": organizationId,
				"nickname": title,
				"title": title,
				"description": description
			]
		]
		return parameters
		
	}
	
	private func requestToCreateChildGroupByUser(organizationId: Int, parentGroup: Int, title: String, description: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "1 groupcreation.Start",
			"jsonrpc": "2.0",
			"method": "groupcreation.Start",
			"params": [
				"oid": organizationId,
				"parent": parentGroup,
				"title": title,
				"nickname": title,
				"description": description
			]
		]
		return parameters
		
	}
	
	private func getByMember() -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": 1,
			"jsonrpc": "2.0",
			"method": "group.GetByMember",
			"params": [
			]
		]
		return parameters
	}
	
	private func getByOrganization(organizationId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "group.GetByOrg",
			"jsonrpc": "2.0",
			"method": "group.GetByOrg",
			"params": [
				"oid": organizationId
			]
		]
		return parameters
	}
	
	private func getInfo(groupId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "group.Get",
			"jsonrpc": "2.0",
			"method": "group.Get",
			"params": [
				"gid": groupId
			]
		]
		return parameters
	}
	
	//MARK: получение всех открытых запросов, на которые пользователь может повлиять
	
	private func getAllRequest() -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "groupcreation.GetAll",
			"jsonrpc": "2.0",
			"method": "groupcreation.GetAll",
			"params": [
			]
		]
		return parameters
	}
	
	private func groupJoinRequestFromAnotherUser(groupId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "groupjoinrequest.Start",
			"jsonrpc": "2.0",
			"method": "groupjoinrequest.Start",
			"params": [
				"gid": groupId
			]
		]
		return parameters
	}
	
	private func confirmGroupCreationRequest(idRequest: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "groupcreation.Accept",
			"jsonrpc": "2.0",
			"method": "groupcreation.Accept",
			"params": [
				"requestID": idRequest
			]
		]
		return parameters
	}
	
	private func denyGroupCreationRequest(idRequest: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "groupcreation.Deny",
			"jsonrpc": "2.0",
			"method": "groupcreation.Deny",
			"params": [
				"requestID": idRequest
			]
		]
		return parameters
	}
	
	private func leaveGroup(groupId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "group.Leave",
			"jsonrpc": "2.0",
			"method": "group.Leave",
			"params": [
				"gid": groupId
			]
		]
		return parameters
	}
	
	private func getAvatar(groupId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "group.GetAvatar",
			"jsonrpc": "2.0",
			"method": "group.GetAvatar",
			"params": [
				"gid": groupId
			]
		]
		return parameters
	}
}
