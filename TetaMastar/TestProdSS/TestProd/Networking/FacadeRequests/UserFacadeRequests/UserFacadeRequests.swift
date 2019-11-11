//
//  TestingFacade.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 09/09/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

enum RequestTypeParams {
	case getInfo(uid: Int)
	case setAboutMe(aboutMeText: String)
	case setFirstName(firstName: String)
	case setNickName(nickName: String)
	case findUser(text: String)
	case getUserAvatar(userId: Int)
	case setEmail(email: String)
}

class UserFacadeRequests {
	
	private let requestType = UserFacadeDataProvider()
	
	public func getRequest(typeParams: RequestTypeParams) {
		let typeRequest = requestType.requests(type: typeParams, setData: nil)
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
	}
	
//	public func setRequests(typeParams: RequestTypeParams, setData: String) {
//		let typeRequest = requestType.requests(type: typeParams, setData: setData)
//
//		do {
//			let jsonData = try JSONSerialization.data(withJSONObject: typeRequest, options: [])
//			WebSocketNetworking.shared.socket.write(data: jsonData)
//		} catch {
//			print("error catch")
//		}
//	}
}
