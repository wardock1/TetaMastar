//
//  UserAuthRequests.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 25/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum UserAuthTypeRequests {
	case sendNotification(login: String, password: String)
	case getToken(login: String, code: Int)
}

class UserAuthRequestsFacade {
	private let requestType = UserAuthDataProvider()
	
	public func getRequest(typeParams: UserAuthTypeRequests) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
}
