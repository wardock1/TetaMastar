//
//  WebSocketNetworking.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 27/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Starscream
import Locksmith

enum TypeIncomingNotification {
	case groupCreated
	case groupJoinRequestStarted
	case groupJoinRequestDeniedOrAccepted
	case groupCreationRequestStarted
	case groupCreationRequestDeniedOrAccepted
	case userAddedToGroup
}

enum WebSocketTypeNotificationRealTime: String {
	case useraddedtogroup
	case groupcreationrequeststarted
	case groupcreationrequestaccepted
	case groupcreationrequestdenied
	case groupjoinrequeststarted
	case groupjoinrequestaccepted
	case groupjoinrequestdenied
}

class WebSocketNetworking {
	
	static var shared = WebSocketNetworking()
	
	var incomingNewNotification: ((String) -> ())?
	
	init() {}
	
	var socket: WebSocket!
	var completionNotificationUserAddedToGroupModel: ((NotificationUserAddedToGroupModel) -> ())?
	
	func startConnectingToWS (token: String, completion: @escaping (Bool) -> Void) {
		var request = URLRequest(url: URL(string: "ws://89.189.159.160:80/api/ws?token=\(token)")!)
		request.addValue("websocket", forHTTPHeaderField: "Upgrade")
		request.addValue("IOSDreamTeam", forHTTPHeaderField: "User-Agent")
		socket = WebSocket(request: request)
		socket.delegate = self
		socket.connect()
		socket.onConnect = {
			completion(true)
		}
	}
	
}

extension WebSocketNetworking: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		print("websocked connected")
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		print("websocked disconnected")
		
		UserDefaults.standard.setIsLoggedIn(value: false)
		do {
			try Locksmith.deleteDataForUserAccount(userAccount: "MyAccount")
		} catch {
			print("error when try delete data from LS")
		}
		print("userDef is false")
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		print("websocketDidReceiveMessage text:")
		
		guard let data = text.data(using: .utf8) else { return }
		
		if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			print("jsonResponse is: \(jsonResponse)")
			
			guard let methodType = jsonResponse["params"] as? [String: Any] else { print("method bad"); return }
			guard let _ = methodType["type"] as? String else { print("notifType bad"); return }
			incomingNewNotification?("hell")
			
		}
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		print("websocketDidReceiveData METHOD data: \(data)")
		
		if let jsonResponse = try? JSONDecoder().decode(ParseTypeNotification.self, from: data) {
			print("first step websocketDidReceiveData: \(jsonResponse.result)")
			let webSocketService = WebSocketService()
			
			var groupCreationRequestStartedUsed = false
			var groupCreationRequestDenied = false
			var userAddedToGroupUsed = false
			var groupJoinRequestStartedUsed = false
			var groupJoinRequestDeniedUsed = false
			var groupCreated = false
			
			jsonResponse.result?.forEach({ (result) in
				
				if result.type == "notification.groupjoinrequestaccepted" {
					if !groupJoinRequestDeniedUsed {
						webSocketService.switchingTypeIncomingNotification(type: .groupJoinRequestDeniedOrAccepted, data: data)
						groupJoinRequestDeniedUsed = true
					}
				}
				
				if result.type == "notification.groupjoinrequestdenied" {
					if !groupJoinRequestDeniedUsed {
						webSocketService.switchingTypeIncomingNotification(type: .groupJoinRequestDeniedOrAccepted, data: data)
						groupJoinRequestDeniedUsed = true
					}
				}
				
				if result.type == "notification.useraddedtogroup" {
					if !userAddedToGroupUsed {
						webSocketService.switchingTypeIncomingNotification(type: .userAddedToGroup, data: data)
						userAddedToGroupUsed = true
					}
				}
				
				if result.type == "notification.groupjoinrequeststarted" {
					if !groupJoinRequestStartedUsed {
						webSocketService.switchingTypeIncomingNotification(type: .groupJoinRequestStarted, data: data)
						groupJoinRequestStartedUsed = true
					}
				}
				
				if result.type == "notification.groupcreationrequeststarted" {
					if !groupCreationRequestStartedUsed {
						webSocketService.switchingTypeIncomingNotification(type: .groupCreationRequestStarted, data: data)
						groupCreationRequestStartedUsed = true
					}
				}
				
				if result.type == "notification.groupcreationrequestdenied" {
					if !groupCreationRequestDenied {
						webSocketService.switchingTypeIncomingNotification(type: .groupCreationRequestDeniedOrAccepted, data: data)
						groupCreationRequestDenied = true
					}
				}
				
				if result.type == "notification.groupcreationrequestaccepted" {
					if !groupCreationRequestDenied {
						webSocketService.switchingTypeIncomingNotification(type: .groupCreationRequestDeniedOrAccepted, data: data)
						groupCreationRequestDenied = true
					}
				}
				
				if result.type == "notification.groupcreated" {
					if !groupCreated {
						webSocketService.switchingTypeIncomingNotification(type: .groupCreated, data: data)
						groupCreated = true
					}
				}
			})
			
		} else {
//			if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
//				print("error JSONDECODER, Serilization: \(jsonResponse)")
//			}
		}
		
	}
}

struct ParseTypeNotification: Decodable {
	
	let result: [result]?
	let params: [params]?
	
	struct result: Decodable {
		let type: String
	}
	
	struct params: Decodable {
		let type: String
	}
}

struct ParseCreationGroupNotificationsGetAllMethod: Decodable {
	let result: [result]
	let id: String
	
	struct result: Decodable {
		let id: Int
		let status: String?
		let title: String?
		let initiator: initiator?
		let parent: parent?
		
		struct initiator: Decodable {
			let id: Int
			let nickname: String
		}
		
		struct parent: Decodable {
			let id: Int
			let title: String
		}
	}
}
