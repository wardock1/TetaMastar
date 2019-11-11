//
//  OrganizationFacadeRequests.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 30/09/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum OrganizationTypeRequest {
	case createOrganization(title: String, description: String)
	case getInfo(idOrganization: Int, nicknameOrganization: String)
	case addUser(idOrganization: Int, idNewUser: Int)
	case removeUser(idOrganization: Int, idRemovedUser: Int)
	case setTitle
	case setDescription
}

class OrganizationFacadeRequests {
	
	private let requestType = OrganizationFacadeDataProvider()
	
	public func getRequest(typeParams: OrganizationTypeRequest) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
	
}
