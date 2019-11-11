//
//  OrganizationFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 05/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum OrganizationTypeRequests {
	case orgCreate(title: String, description: String)
	case orgDelete(orgId: Int)
	case orgGet(orgId: Int)
	case orgAddUser(orgId: Int, userId: Int)
	case orgGetAvatar(orgId: Int)
	case orgRemoveUser(orgId: Int, userId: Int)
	case orgSetAvatar(orgId: Int, avatar: String)
	case orgSetTitle(orgId: Int, title: String)
	case orgSetDescription(orgId: Int, description: String)
	case orgSetDirector(orgId: Int, userId: Int)
	case orgFind(title: String)
	case orgEnableRating(orgId: Int)
	case orgDisableRating(orgId: Int)
	case orgGetAllByAdmin
}

class OrganizationRequestsFacade {
	
	private let requestType = OrganizationDataProvider()
	
	public func getRequest(typeParams: OrganizationTypeRequests) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
	
}
