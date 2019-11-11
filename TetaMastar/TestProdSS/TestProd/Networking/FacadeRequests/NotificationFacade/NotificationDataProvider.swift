//
//  NotificationDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class NotificationDataProvider {
	
	public func requests(type: FacadeTypeRequests) -> [String: Any] {
		switch type {
		case .unseenNotification:
			return unseenNotification()
		case .markNotification(let idNotification):
			return markNotification(idNotification: idNotification)
		}
	}
	
	private func unseenNotification() -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "notification.Unseen",
			"jsonrpc": "2.0",
			"method": "notification.Unseen",
			"params": [
			]
		]
		return parameters
	}
	
	private func markNotification(idNotification: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "notification.Mark",
			"jsonrpc": "2.0",
			"method": "notification.Mark",
			"params": [
				"notifID": idNotification
			]
		]
		return parameters
	}
	
}
