//
//  WebSocketService.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 21/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//


import Foundation

class WebSocketService  {
	
	static var notificationUserAddedToGroupCompletion: (([NotificationUserAddedToGroupModel.result]) -> Void)?
	static var notificationGroupCreatedCompletion: (([NotificationGroupCreatedModel.result]) -> ())?
	static var notificationGroupCreatedRequestStartedCompletion: (([NotificationGpCreationRequestStarted.result]) -> ())?
	static var notificationGroupCreateRequestDeniedAcceptedCompletion: (([NotificationGroupCreatedRequestDeniedAccepted.result]) -> ())?
	static var notificationGroupCreateRequestAcceptedCompletion: (([NotificationGroupCreatedRequestDeniedAccepted.result]) -> ())?
	
	static var notificationJoinRequestStartedCompletion: (([JoinRequestStartedModel.result]) -> ())?
	
	
	static var notificationGroupCreateRequestGetAllCompletion: (([ParseCreationGroupNotificationsGetAllMethod.result]) -> ())?
	
	
	func switchingTypeIncomingNotification(type: TypeIncomingNotification, data: Data) {
		switch type {
		case .groupCreated:
			print("groupCreated")
			do {
				let groupCreated = try genericParse(type: NotificationGroupCreatedModel.self, data: data)
				var storageNotificationArray = [NotificationGroupCreatedModel.result]()
				groupCreated.result?.forEach({ (result) in
					if result.type == "notification.groupcreated" {
						storageNotificationArray.append(result)
					}
				})
				dataPassGroupCreated(model: storageNotificationArray)
				
			} catch let error {
				print("switchingTypeIncomingNotification groupCreated erro: \(error)")
			}
			
		case .groupJoinRequestStarted:
			print("groupJoinRequestStarted")
			do {
				let joinToGroupRequestStarted = try genericParse(type: JoinRequestStartedModel.self, data: data)
				var storageNotificationArray = [JoinRequestStartedModel.result]()
				joinToGroupRequestStarted.result?.forEach({ (result) in
					if result.type == "notification.groupjoinrequeststarted" {
						storageNotificationArray.append(result)
					}
				})
				
				dataPassJoinRequestToGroup(model: storageNotificationArray)
				
			} catch let error {
				print("switchingTypeIncomingNotification groupJoinRequestStarted erro: \(error)")
			}
			
		case .groupJoinRequestDeniedOrAccepted:
			print("groupJoinRequestDenied")
			
			do {
				let groupJoinRequestDenied = try genericParse(type: JoinRequestStartedModel.self, data: data)
				var storageNotificationArray = [JoinRequestStartedModel.result]()
				groupJoinRequestDenied.result?.forEach({ (result) in
					if result.type == "denied" {
						storageNotificationArray.append(result)
					}
					if result.type == "confirmed" {
						storageNotificationArray.append(result)
					}
				})
				dataPassJoinRequestToGroup(model: storageNotificationArray)
				
			} catch let error {
				print("groupJoinRequestDenied error: \(error)")
			}
			
			
		case .groupCreationRequestStarted:
			print("groupCreationRequestStarted")
			do {
				let groupCreationRequestStarted = try genericParse(type: NotificationGpCreationRequestStarted.self, data: data)
				var storageNotificationArray = [NotificationGpCreationRequestStarted.result]()
				groupCreationRequestStarted.result?.forEach({ (result) in
					if result.type == "notification.groupcreationrequeststarted" {
						storageNotificationArray.append(result)
					}
				})
				
				dataPassGroupCreatedRequestStarted(model: storageNotificationArray)
				
			} catch let error {
				print("switchingTypeIncomingNotification groupCreationRequestStarted erro: \(error)")
			}
			
		case .groupCreationRequestDeniedOrAccepted:
			print("groupCreationRequestDenied")
			do {
				let groupCreatedRequestDenied = try genericParse(type: NotificationGroupCreatedRequestDeniedAccepted.self, data: data)
				
				var storageNotificationArray = [NotificationGroupCreatedRequestDeniedAccepted.result]()
				groupCreatedRequestDenied.result?.forEach({ (result) in
					if result.type == "notification.groupcreationrequestdenied" {
						storageNotificationArray.append(result)
					}
					if result.type == "notification.groupcreationrequestaccepted" {
						storageNotificationArray.append(result)
					}
					
				})
				dataPassGroupCreationRequestDenied(model: storageNotificationArray)
				
			} catch let error {
				print("switchingTypeIncomingNotification groupCreationRequestDenied erro: \(error)")
			}
			
		case .userAddedToGroup:
			print("userAddedToGroup")
			do {
				let userAddedData = try genericParse(type: NotificationUserAddedToGroupModel.self, data: data)
				var storageNotificationArray = [NotificationUserAddedToGroupModel.result]()
				userAddedData.result?.forEach({ (result) in
					if result.type == "notification.useraddedtogroup" {
						storageNotificationArray.append(result)
					}
				})
				dataPassUserAddedToGroup(model: storageNotificationArray)
				
			} catch let error {
				print("switchingTypeIncomingNotification UserAddedToGroup erro: \(error)")
			}
		}
	}
	
	private func genericParse<T: Decodable>(type: T.Type, data: Data) throws -> T {
		print("genericParseMethod")
		return try JSONDecoder().decode(type.self, from: data)

	}
	
	private func dataPassUserAddedToGroup(model: [NotificationUserAddedToGroupModel.result]) {
		WebSocketService.notificationUserAddedToGroupCompletion?(model)
	}
	
	private func dataPassGroupCreationRequestDenied(model: [NotificationGroupCreatedRequestDeniedAccepted.result]) {
		WebSocketService.notificationGroupCreateRequestDeniedAcceptedCompletion?(model)
	}
	
	private func dataPassGroupCreatedRequestStarted(model: [NotificationGpCreationRequestStarted.result]) {
		WebSocketService.notificationGroupCreatedRequestStartedCompletion?(model)
	}
	
	private func dataPassGroupCreated(model: [NotificationGroupCreatedModel.result]) {
		WebSocketService.notificationGroupCreatedCompletion?(model)
	}
	
	private func dataPassJoinRequestToGroup(model: [JoinRequestStartedModel.result]) {
		WebSocketService.notificationJoinRequestStartedCompletion?(model)
	}
}
