//
//  OrganizationDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 05/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation


class OrganizationDataProvider {
	
	func requests(type: OrganizationTypeRequests) -> [String: Any] {
		switch type {
		case .orgCreate(let title, let description):
			return orgCreate(title: title, description: description)
			
		case .orgDelete(let orgId):
			return orgDelete(orgId: orgId)
			
		case .orgGet(let orgId):
			return orgGet(orgId: orgId)
			
		case .orgAddUser(let orgId, let userId):
			return orgAddUser(orgId: orgId, userId: userId)
			
		case .orgGetAvatar(let orgId):
			return orgGetAvatar(orgId: orgId)
			
		case .orgRemoveUser(let orgId, let userId):
			return orgRemoveUser(orgId: orgId, userId: userId)
			
		case .orgSetAvatar(let orgId, let avatar):
			return orgSetAvatar(orgId: orgId, avatar: avatar)
			
		case .orgSetTitle(let orgId, let title):
			return orgSetTitle(orgId: orgId, title: title)
			
		case .orgSetDescription(let orgId, let description):
			return orgSetDescription(orgId: orgId, description: description)
			
		case .orgSetDirector(let orgId, let userId):
			return orgSetDirector(orgId: orgId, userId: userId)
			
		case .orgFind(let title):
			return orgFind(title: title)
			
		case .orgEnableRating(let orgId):
			return orgEnableRating(orgId: orgId)
			
		case .orgDisableRating(let orgId):
			return orgDisableRating(orgId: orgId)
			
		case .orgGetAllByAdmin:
			return orgGetAllByAdmin()
		}
	}
	
	private func orgCreate(title: String, description: String) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.Create",
			"jsonrpc": "2.0",
			"method": "organization.Create",
			"params": [
				"nickname": title,
				"title": title,
				"description": description
			]
		]
		return parameters
	}
	
	private func orgDelete(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.Delete",
			"jsonrpc": "2.0",
			"method": "organization.Delete",
			"params": [
				"oid": orgId
			]
		]
		return parameters
	}
	
	private func orgGet(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.Get",
			"jsonrpc": "2.0",
			"method": "organization.Get",
			"params": [
				"id": orgId
			]
		]
		return parameters
	}
	
	private func orgAddUser(orgId: Int, userId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.AddUser",
			"jsonrpc": "2.0",
			"method": "organization.AddUser",
			"params": [
				"oid": orgId,
				"uid": userId
			]
		]
		return parameters
	}
	
	private func orgGetAvatar(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.GetAvatar",
			"jsonrpc": "2.0",
			"method": "organization.GetAvatar",
			"params": [
				"oid": orgId
			]
		]
		return parameters
	}
	
	private func orgRemoveUser(orgId: Int, userId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.RemoveUser",
			"jsonrpc": "2.0",
			"method": "organization.RemoveUser",
			"params": [
				"oid": orgId,
				"uid": userId
			]
		]
		return parameters
	}
	
	private func orgSetAvatar(orgId: Int, avatar: String) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.SetAvatar",
			"jsonrpc": "2.0",
			"method": "organization.SetAvatar",
			"params": [
				"oid": orgId,
				"avatar": avatar
			]
		]
		return parameters
	}
	
	private func orgSetTitle(orgId: Int, title: String) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.SetTitle",
			"jsonrpc": "2.0",
			"method": "organization.SetTitle",
			"params": [
				"oid": orgId,
				"avatar": title
			]
		]
		return parameters
	}
	
	private func orgSetDescription(orgId: Int, description: String) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.SetDescription",
			"jsonrpc": "2.0",
			"method": "organization.SetDescription",
			"params": [
				"oid": orgId,
				"avatar": description
			]
		]
		return parameters
	}
	
	private func orgSetDirector(orgId: Int, userId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.SetDirector",
			"jsonrpc": "2.0",
			"method": "organization.SetDirector",
			"params": [
				"oid": orgId,
				"uid": userId
			]
		]
		return parameters
	}
	
	private func orgFind(title: String) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.Find",
			"jsonrpc": "2.0",
			"method": "organization.Find",
			"params": [
				"text": title
			]
		]
		return parameters
	}
	
	private func orgEnableRating(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.EnableRating",
			"jsonrpc": "2.0",
			"method": "organization.EnableRating",
			"params": [
				"oid": orgId
			]
		]
		return parameters
	}
	
	private func orgDisableRating(orgId: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.DisableRating",
			"jsonrpc": "2.0",
			"method": "organization.DisableRating",
			"params": [
				"oid": orgId
			]
		]
		return parameters
	}
	
	private func orgGetAllByAdmin() -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "organization.GetByAdmin",
			"jsonrpc": "2.0",
			"method": "organization.GetByAdmin",
			"params": [
			]
		]
		return parameters
	}
	
}
