//
//  NotificationFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum FacadeTypeRequests {
	case unseenNotification
	case markNotification(idNotification: Int)
}

class NotificationFacade {
	
	private let requestType = NotificationDataProvider()
	
	public func getRequest(typeParams: FacadeTypeRequests) {
		let typeRequest = requestType.requests(type: typeParams)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
}
