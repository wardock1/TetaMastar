//
//  UserAuthDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 25/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class UserAuthDataProvider {
	
	func requests(type: UserAuthTypeRequests) -> [String: Any] {
		switch type {
		case .sendNotification(let login, let password):
			return sendNotification(login: login, password: password)
		case .getToken(let login, let code):
			return getToken(login: login, code: code)
		}
		
	}
	
	private func sendNotification(login: String, password: String) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "code.SendNotification",
			"jsonrpc": "2.0",
			"method": "code.SendNotification",
			"params": [
				"phone": login,
				"password": password
			]
		]
		return parameters
	}
	
	private func getToken(login: String, code: Int) -> [String: Any] {
		let parameters: [String: Any] = [
			"id": "token.Get",
			"jsonrpc": "2.0",
			"method": "token.Get",
			"params": [
				"phone": login,
				"code": code
			]
		]
		return parameters
	}
}
