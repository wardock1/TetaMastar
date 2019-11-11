//
//  EventController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 01/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Starscream

enum TypeNotificationCell {
	case groupCreated
	case joinRequest
	case groupCreatedStartedRequest
	case groupCreatedRequestDenied
	case userAddedToGroup
}

class EventController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	lazy var refresher: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.tintColor = .white
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		return refreshControl
	}()
	
	@objc func refreshData() {
		print("REFRESH")
		items.removeAll()
		fetchInfoAboutInvitations()
		refresher.endRefreshing()
	}
	
	var items = [TypeCellViewModelItem]() {
		didSet {
			print("items was been changed count: \(self.items.count)")
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.tableView.allowsSelection = false
		fetchInfoAboutInvitations()
		updateData()
		trackIncomingNewNotification()
		tableView.refreshControl = refresher
		tableView.separatorStyle = .none
	}
	
	deinit {
		print("eventController deinited")
	}
	
	func updateData() {
		WebSocketService.notificationGroupCreatedCompletion = {[weak self] data in
			guard let self = self else { return }
			if data.count != 0 {
				let groupCreated = GroupCreated(groupCreated: data)
				self.items.append(groupCreated)
			}
		}
		
		WebSocketService.notificationGroupCreatedRequestStartedCompletion = {[weak self] data in
			guard let self = self else { return }
			if data.count != 0 {
				let groupCreatedReqeustStarted = GroupCreatedStartedRequest(groupCreatedRequestStarted: data)
				self.items.append(groupCreatedReqeustStarted)
			}
		}
		
		WebSocketService.notificationGroupCreateRequestDeniedAcceptedCompletion = {[weak self] data in
			guard let self = self else { return }
			if data.count != 0 {
				let groupCreateRequestDeniedAccepted = GroupCreatedRequestDenied(groupCreatedRequestDenied: data)
				self.items.append(groupCreateRequestDeniedAccepted)
			}
		}
		
		WebSocketService.notificationJoinRequestStartedCompletion = {[weak self] data in
			guard let self = self else { return }
			if data.count != 0 {
				let joinToGroupRequestStarted = JoinToGroupReqeustStarted(joinRequestStarted: data)
				self.items.append(joinToGroupRequestStarted)
			}
		}
		
		WebSocketService.notificationUserAddedToGroupCompletion = {[weak self] data in
			guard let self = self else { return }
			if data.count != 0 {
				let userAddedToGroup = UserAddedToGroup(userAddedToGroup: data)
				self.items.append(userAddedToGroup)
			}
		}
	}
	
	func fetchInfoAboutInvitations() {
		print("fetchInfoAboutInvitations fetchInfoAboutInvitations fetchInfoAboutInvitations fetchInfoAboutInvitations")
		let unseenNotifications = NotificationFacade()
		unseenNotifications.getRequest(typeParams: .unseenNotification)
	}
	
	func trackIncomingNewNotification() {
		WebSocketNetworking.shared.incomingNewNotification = {[weak self] data in
			guard let self = self else { return }
			self.refreshData()
		}
	}
	
}

extension EventController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		//		print("numberOfSections is: \(items.count)")
		return items.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//		print("numberOfRowsInSection is: \(items[section].rowCount)")
		return items[section].rowCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let item = items[indexPath.section]
		switch item.type {
		case .joinRequest:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "EventControllerCell", for: indexPath) as? JoinRequestStartedCell {
				cell.currentJoinRequestAndIndexPath(at: indexPath, currentRequest: cell)
				cell.joinToGroupStartedDelegate = self
				cell.item = item
				
				return cell
			}
		case .groupCreated:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "JoinRequestCell", for: indexPath) as? GroupCreatedCell {
				cell.currentGroupCreatedNotificationAndIndexPath(at: indexPath, dataInvitation: cell)
				cell.item = item
				
				return cell
			}
		case .groupCreatedStartedRequest:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "EventRequestStartedCell", for: indexPath) as? GroupCreateStartedRequestCell {
				cell.currentGroupCreationRequestAndIndexPath(at: indexPath, currentRequest: cell)
				cell.groupCreatingRespondentDelegate = self
				cell.item = item
				
				return cell
			}
		case .groupCreatedRequestDenied:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCreatedRequestCell", for: indexPath) as? GroupCreatedRequestDeniedCell {
				cell.currentDeniedRequestAndIndexPath(at: indexPath, currentRequest: cell)
				cell.markDeniedNotificationDelegate = self
				cell.item = item
				
				return cell
			}
		case .userAddedToGroup:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "userAddedToGroupCell", for: indexPath) as? UserAddedToGroupCell {
				cell.currentUserAddedNotifAndIndexPath(at: indexPath, currentUserAddedNotif: cell)
				cell.markNotificationUserAddedToGroupDelegate = self
				cell.item = item
				
				return cell
			}
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 160
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
}

extension EventController: InvitationDeclinedbly, NotificationMarkable, GroupCreationRequestRespondent, GroupCreationNotificationDeniedMarkble, UserAddedToGroupMarkble {
	
	func markNotificationUserAddedToGroup(at indexPath: IndexPath, requestData: UserAddedToGroupCell) {
		guard let itemd = requestData.item as? UserAddedToGroup else {print("markNotificationUserAddedToGroup error:"); return }
		let notificationFacade = NotificationFacade()
		guard let notificationRequestId = itemd.userAddedToGroup[indexPath.row].data?.id else {print("markNotificationUserAddedToGroup ID error:"); return }
		
		notificationFacade.getRequest(typeParams: .markNotification(idNotification: notificationRequestId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
					print("jsonResponse: \(jsonResponse)")
					let indexSet = IndexSet(integer: indexPath.section)
					
					if itemd.rowCount == 1 {
						itemd.deletingDataWithIndexPath(with: indexPath)
						self.items.remove(at: indexPath.section)
						self.tableView.deleteSections(indexSet, with: .automatic)
					}
					
					if itemd.rowCount > 1 {
						itemd.deletingDataWithIndexPath(with: indexPath)
						
						self.tableView.beginUpdates()
						self.tableView.deleteRows(at: [indexPath], with: .automatic)
						self.tableView.endUpdates()
						self.tableView.reloadSections(indexSet, with: .automatic)
					}
				} catch let error {
					print("error seriliaz: \(error)")
				}
			}
		
		}
		
		
		func markGroupCreationDeniedNotification(for indexPath: IndexPath, requestData: GroupCreatedRequestDeniedCell) {
			print("markGroupCreationDeniedNotif indexpath is: \(indexPath)")
			let indexSet = IndexSet(integer: indexPath.section)
			
			guard let itemd = requestData.item as? GroupCreatedRequestDenied else {print("markGroupCreationDeniedNotification error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				print("HJWHWHDHWHWDWH")
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
			
		}
		
		
		func declineGroupCreation(for indexPath: IndexPath, requestData: GroupCreateStartedRequestCell) {
			print("decline GP request")
			
			
			let indexSet = IndexSet(integer: indexPath.section)
			guard let itemd = requestData.item as? GroupCreatedStartedRequest else {print("declineGroupCreation error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
			
//			let requestId = itemd.groupCreatedRequestStartedNW[indexPath.row].data?.request?.id
//			print("requestId is: \(String(describing: requestId))")
		}
		
		func confirmGroupCreationg(for indexPath: IndexPath, requestData: GroupCreateStartedRequestCell) {
			print("confirm GP request")
			let indexSet = IndexSet(integer: indexPath.section)
			guard let itemd = requestData.item as? GroupCreatedStartedRequest else {print("confirmGroupCreationg error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
		}
		
		func markGroupCreationRequest(for indexPath: IndexPath, requestData: GroupCreateStartedRequestCell) {
			let indexSet = IndexSet(integer: indexPath.section)
			guard let itemd = requestData.item as? GroupCreatedStartedRequest else {print("markGroupCreationRequest error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
		}
		
		func markNotificationGroupCreated(for indexPath: IndexPath, requestData: GroupCreatedCell) {
			let indexSet = IndexSet(integer: indexPath.section)
			guard let itemd = requestData.item as? GroupCreated else {print("markNotificationGroupCreated error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
		}
		
		
		func confirmJoinRequestToGroup(for indexPath: IndexPath, invitationData: JoinRequestStartedCell) {
			print("delegate confirm works indexx: \(indexPath)")
			let indexSet = IndexSet(integer: indexPath.section)
			guard let itemd = invitationData.item as? JoinToGroupReqeustStarted else {print("confirmJoinRequestToGroup error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
		}
		
		func declineJoinRequestToGroup(for indexPath: IndexPath, invitationData: JoinRequestStartedCell) {
			print("delegate decline works indexx: \(indexPath)")
			let indexSet = IndexSet(integer: indexPath.section)
			guard let itemd = invitationData.item as? JoinToGroupReqeustStarted else {print("declineJoinRequestToGroup error:"); return }
			
			if itemd.rowCount == 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				items.remove(at: indexPath.section)
				tableView.deleteSections(indexSet, with: .automatic)
			}
			
			if itemd.rowCount > 1 {
				itemd.deletingDataWithIndexPath(with: indexPath)
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.endUpdates()
				tableView.reloadSections(indexSet, with: .automatic)
			}
		}
	}
	
	protocol TypeCellViewModelItem {
		var type: TypeNotificationCell { get }
		var rowCount: Int { get }
		var sectionTitle: String  { get }
	}
	
	class JoinToGroupReqeustStarted: TypeCellViewModelItem {
		var type: TypeNotificationCell {
			return .joinRequest
		}
		
		var sectionTitle: String {
			return "JR"
		}
		
		var joinRequestStarted: [JoinRequestStartedModel.result]
		init(joinRequestStarted: [JoinRequestStartedModel.result]) {
			self.joinRequestStarted = joinRequestStarted
		}
		
		var rowCount: Int {
			return joinRequestStarted.count
		}
		
		func deletingDataWithIndexPath(with indexPath: IndexPath) {
			joinRequestStarted.remove(at: indexPath.row)
		}
	}
	
	class GroupCreated: TypeCellViewModelItem {
		var type: TypeNotificationCell {
			return .groupCreated
		}
		
		var sectionTitle: String {
			return "GP"
		}
		
		var groupCreated: [NotificationGroupCreatedModel.result]
		init(groupCreated: [NotificationGroupCreatedModel.result]) {
			self.groupCreated = groupCreated
		}
		
		var rowCount: Int {
			return groupCreated.count
		}
		
		func deletingDataWithIndexPath(with indexPath: IndexPath) {
			groupCreated.remove(at: indexPath.row)
		}
	}
	
	class GroupCreatedStartedRequest: TypeCellViewModelItem {
		var type: TypeNotificationCell {
			return .groupCreatedStartedRequest
		}
		
		var sectionTitle: String {
			return "GroupCreatedStartedRequest"
		}
		
		var groupCreatedRequestStartedNW: [NotificationGpCreationRequestStarted.result]
		init(groupCreatedRequestStarted: [NotificationGpCreationRequestStarted.result]) {
			self.groupCreatedRequestStartedNW = groupCreatedRequestStarted
		}
		
		var rowCount: Int {
			return groupCreatedRequestStartedNW.count
		}
		
		func deletingDataWithIndexPath(with indexPath: IndexPath) {
			groupCreatedRequestStartedNW.remove(at: indexPath.row)
		}
	}
	
	class GroupCreatedRequestDenied: TypeCellViewModelItem {
		var type: TypeNotificationCell {
			return .groupCreatedRequestDenied
		}
		
		
		var sectionTitle: String {
			return "groupcreationrequestdenied"
		}
		
		var groupCreatedRequestDenied: [NotificationGroupCreatedRequestDeniedAccepted.result]
		init(groupCreatedRequestDenied: [NotificationGroupCreatedRequestDeniedAccepted.result]) {
			self.groupCreatedRequestDenied = groupCreatedRequestDenied
		}
		
		
		var rowCount: Int {
			return groupCreatedRequestDenied.count
		}
		
		func deletingDataWithIndexPath(with indexPath: IndexPath) {
			groupCreatedRequestDenied.remove(at: indexPath.row)
		}
	}
	
	class UserAddedToGroup: TypeCellViewModelItem {
		var type: TypeNotificationCell {
			return .userAddedToGroup
		}
		
		var sectionTitle: String {
			return "UserAddedToGroup"
		}
		
		var userAddedToGroup: [NotificationUserAddedToGroupModel.result]
		init(userAddedToGroup: [NotificationUserAddedToGroupModel.result]) {
			self.userAddedToGroup = userAddedToGroup
		}
		
		var rowCount: Int {
			return userAddedToGroup.count
		}
		
		func deletingDataWithIndexPath(with indexPath: IndexPath) {
			userAddedToGroup.remove(at: indexPath.row)
		}
}
