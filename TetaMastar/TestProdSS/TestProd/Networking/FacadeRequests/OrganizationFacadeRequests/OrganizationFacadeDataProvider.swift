//
//  OrganizationFacadeDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 30/09/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Locksmith

class OrganizationFacadeDataProvider {
	
//	private func getUserId() -> Int {
//		guard let lockSmithInfo = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else {
//			return 0
//		}
//		if let userId = lockSmithInfo["userId"] as? Int {
//			return userId
//		}
//		return 0
//	}
	
	public func requests(type: OrganizationTypeRequest) -> [String: Any] {
		switch type {
		case .createOrganization(let title, let descriptiong):
			return createOrganization(title: title, description: descriptiong)
		case .getInfo(let id, let nicknameOrganization):
			return getInfo(id: id, nicknameOrganization: nicknameOrganization)
		case .addUser(let idOrganization, let id):
			return addUser(idOrganization: idOrganization, idNewUser: id)
		case .removeUser(let idOrganization, let idRemovedUser):
			return removeUser(idOrganization: idOrganization, idRemovedUser: idRemovedUser)
		case .setTitle:
			return setTitle()
		case .setDescription:
			return setDescription()
		}
	}
	
	private func createOrganization(title: String, description: String) -> [String: Any] {
		
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
	
	private func getInfo(id: Int, nicknameOrganization: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "organization.getInfo",
			"jsonrpc": "2.0",
			"method": "organization.Get",
			"params": [
				"nickname": nicknameOrganization,
				"id": id
			]
		]
		return parameters
	}
	
	private func addUser(idOrganization: Int, idNewUser: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "organization.AddUser",
			"jsonrpc": "2.0",
			"method": "organization.Create",
			"params": [
				"oid": idOrganization,
				"uid": idNewUser
			]
		]
		return parameters
	}
	
	private func removeUser(idOrganization: Int, idRemovedUser: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "organization.AddUser",
			"jsonrpc": "2.0",
			"method": "organization.Create",
			"params": [
				"oid": idOrganization,
				"uid": idRemovedUser
			]
		]
		return parameters
	}
	
	private func setTitle() -> [String: Any] {
		return ["": 22]
	}
	
	private func setDescription() -> [String: Any] {
		return ["": 22]
	}
}
