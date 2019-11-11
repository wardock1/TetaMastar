//
//  DetailViewController.swift
//  TestProd
//
//  Created by Developer on 15/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	
	@IBOutlet weak var imageGroup: UIImageView!
	@IBOutlet weak var groupName: UILabel!
	@IBOutlet weak var groupDescription: UITextView!
	@IBOutlet weak var allUsersButton: UIButton!
	@IBOutlet weak var allEventsButton: UIButton!
	@IBOutlet weak var tableViewController: UITableView!
	@IBOutlet weak var newEventButton: UIButton!
	@IBOutlet weak var requestToAddNewSubGroupButton: UIButton!
	@IBOutlet weak var leaveGroupButton: UIButton!
	@IBOutlet weak var showSubGroupsButton: UIButton!
	@IBOutlet weak var groupAdminLabel: UILabel!
	
	var storageNameLabel: String?
	var storageDescrpLabel: String?
	var storageAvatarGroup: UIImage?
	var storageIdGroup: String?
	var storageGroupDetail: [GroupList]?
	var storageEventID: String?
	var storageAdminIdLabel: Int? {
		didSet {
			if let adminId = self.storageAdminIdLabel {
				gettingInfoAboutGroupid(userId: adminId)
			}
		}
	}
	
	var someArray = [GroupList]()
	var groupDetail = [GroupList]()
	var currentEventList = [Event]()
	
	var currentGroupListResult = [NewGroupListWithAvatar1.result]()
	var storageCurrentGroupListData = [NewGroupListWithAvatar1.result]()
	
	var completionGroupId: ((Int) -> ())?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDecorationButtons()
		imageGroup.layer.cornerRadius = 0.5 * imageGroup.bounds.size.width
		tableViewController.delegate = self
		tableViewController.dataSource = self
		tableViewController.separatorStyle = .none
		
        getCurrentEvents()
		currentGroupListResult = storageCurrentGroupListData
		groupName.text = storageNameLabel
		groupDescription.text = storageDescrpLabel
		imageGroup.image = storageAvatarGroup
	}
	
	deinit {
		print("detailVC deinited")
	}
	
	func setDecorationButtons() {
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		allUsersButton.layer.cornerRadius = 17
		allUsersButton.layer.masksToBounds = true
		allUsersButton.backgroundColor = .clear
		allUsersButton.layer.setGradienBorder(colors: bor, width: 1)
		
		allEventsButton.layer.cornerRadius = 17
		allEventsButton.layer.masksToBounds = true
		allEventsButton.backgroundColor = .clear
		allEventsButton.layer.setGradienBorder(colors: bor, width: 1)
		
		requestToAddNewSubGroupButton.layer.cornerRadius = 17
		requestToAddNewSubGroupButton.layer.masksToBounds = true
		requestToAddNewSubGroupButton.backgroundColor = .clear
		requestToAddNewSubGroupButton.layer.setGradienBorder(colors: bor, width: 1)
		
		leaveGroupButton.layer.cornerRadius = 17
		leaveGroupButton.layer.masksToBounds = true
		leaveGroupButton.backgroundColor = .clear
		leaveGroupButton.layer.setGradienBorder(colors: bor, width: 1)
		
		showSubGroupsButton.layer.cornerRadius = 17
		showSubGroupsButton.layer.masksToBounds = true
		showSubGroupsButton.backgroundColor = .clear
		showSubGroupsButton.layer.setGradienBorder(colors: bor, width: 1)
		
		newEventButton.layer.cornerRadius = 17
	}
	
	
    func getCurrentEvents() {
		
		
    }
	
	func getInfoAboutEvent() {
		
	}
	
	func gettingInfoAboutGroupid(userId: Int) {
		let userRequestFacade = UserFacadeRequests()
		userRequestFacade.getRequest(typeParams: .getInfo(uid: userId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			
			do {
				let jsonResponse = try JSONDecoder().decode(NewUser.self, from: data)
				guard let adminName = jsonResponse.result.firstName ?? jsonResponse.result.nickname else { return }
				self.groupAdminLabel.text = "Админ группы \(adminName)"
				
			} catch let error {
				print("gettingInfoAboutGroupid \(error)")
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "fromGroupToMembers" {
			let destinationVC = segue.destination as? MembersControllerView
			
			var groupId1 = 0
			currentGroupListResult.forEach { (result) in
				groupId1 = result.id
			}
			print("groupID: \(groupId1)")
			destinationVC?.storageIdGroup = groupId1
			
		}
		
		if segue.identifier == "fromDetailToCreateSubGroup" {
			guard let destinationVC = segue.destination as? CreateSubGroupController else { return }
			destinationVC.storageCurrentGroupListData = currentGroupListResult
			
		}
		
		if segue.identifier == "fromDetailToSubGroup" {
			guard let destinationVC = segue.destination as? SubGroupController else { return }
			destinationVC.storageCurrentGroupListResult = currentGroupListResult
			
		}
	}
	@IBAction func createNewEventButtonTapped(_ sender: UIButton) {
//		if let newEventView = storyboard?.instantiateViewController(withIdentifier: "newEventView") as? NewEventMainController {
//			var currentOrgId = 00
//			storageCurrentGroupListData.forEach { (result) in
//				currentOrgId = result.organization.id
//			}
//
//			newEventView.storageOrgId = currentOrgId
//			navigationController?.pushViewController(newEventView, animated: true)
//		}
	}
	@IBAction func leaveGroupButtonTapped(_ sender: UIButton) {
		var groupId = 0
		currentGroupListResult.forEach { (result) in
			groupId = result.id
		}
		
		let groupFacade = GroupFacadeRequests()
		groupFacade.getRequest(typeParams: .leaveGroup(groupId: groupId))
		
		WebSocketNetworking.shared.socket.onData = { [weak self] data in
			guard let self = self else { return }
			do {
				if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
					if let resultError = jsonResponse["error"] as? [String: Any] {
						guard let codeError = resultError["code"] as? Int else { print("error message"); return }
						if codeError == 58 {
							self.alertCommand(title: "Ошибка", message: "Админ не может покинуть свою группу")
						}
					}
					
				} else {
					let jsonResponse = try JSONDecoder().decode(RatingAnswerOkResponse.self, from: data)
					print("jsonResponse leave: \(jsonResponse)")
					
					if jsonResponse.result?.message == "ok" {
						self.alertCommand(title: "Leaved from group", message: "")
						self.navigationController?.popViewController(animated: true)
					}
				}
				
			} catch {
				print("error leave")
			}
		}
	}
	
	func unAnsweredInGroup(currentRatingData: [RatingInMyGroupModel.result], completion: @escaping ([UnAnsweredUsers.result]) -> ()) {
		var groupId = 0
		var ratingId = 0

		currentGroupListResult.forEach { (result) in
			groupId = result.id
			print("groupId: \(groupId)")
		}

		currentRatingData.forEach { (result) in
			guard let storage = result.id else { return }
			ratingId = storage
		}

		let ratingFacade = RatingRequestsFacade()
		ratingFacade.getRequest(typeParams: .unAnsweredInGroup(raitingId: ratingId, groupId: groupId))

		WebSocketNetworking.shared.socket.onData = { [weak self] data in
			guard let self = self else { return }
			print("unAnsweredInGroup ww")

			do {
				let jsonResponse = try JSONDecoder().decode(UnAnsweredUsers.self, from: data)
				print("jsonResponse: \(jsonResponse)")
				completion(jsonResponse.result)
				
			} catch let error {
				self.alertCommand(title: "Ошибка", message: "неизвестная ошибка")
				print("alleventbutton error: \(error)")
			}

		}
	}
	
//	func choiceFirstMemberInGroupForRating(groupId: Int, data: Data, completion: @escaping ([GroupInfoModel.result.community.members]) -> ()) {
//
//		let groupFacade = GroupFacadeRequests()
//		groupFacade.getRequest(typeParams: .getInfo(groupId: groupId))
//
//		WebSocketNetworking.shared.socket.onData = { data in
//
//			do {
//				let jsonResponse = try JSONDecoder().decode(GroupInfoModel.self, from: data)
//				print("firstmember response)")
//				guard let complect = jsonResponse.result?.community?.members else { print("firstmember error"); return }
//				completion(complect)
//
//			} catch let error {
//				print("error choiceFirstMemb; \(error)")
//			}
//		}
//	}
	
	@IBAction func allEventsButtonTapped(_ sender: UIButton) {
		
		let ratingFacade = RatingRequestsFacade()
		ratingFacade.getRequest(typeParams: .isRatingNowInMyGroup)
		
		WebSocketNetworking.shared.socket.onData = { [weak self] data in
			guard let self = self else { return }
			
			print("alleventbuttonTapped")
			do {
				let jsonResponse = try JSONDecoder().decode(RatingInMyGroupModel.self, from: data)
				print("jsonResponse: \(jsonResponse)")
				
				if jsonResponse.result.count == 0 {
					self.alertCommand(title: "Ошибка", message: "На текущий момент открытых голосований нет")
				} else if let voteView = self.storyboard?.instantiateViewController(withIdentifier: "voteView") as? VoteViewController {
					
//					var guid = 0
//
//					self.currentGroupListResult.forEach({ (result) in
//						guid = result.id
//					})
					let currentRating = jsonResponse.result
					
//					self.choiceFirstMemberInGroupForRating(groupId: guid, data: data, completion: { [weak self] (result) in
//						guard let self = self else { return }
//
//						if let randomPolluser = result.randomElement() {
//							voteView.storageCurrentResultRating = currentRating
//							voteView.storagePollUserId = randomPolluser.id
//							voteView.storagePollUserName = randomPolluser.nickname
//
//							self.present(voteView, animated: true, completion: nil)
//						}
//					})
					
					self.unAnsweredInGroup(currentRatingData: currentRating, completion: { (result) in
						
						if result.count == 0 {
							self.alertCommand(title: "", message: "Все пользователи оценены")
						}else if let randomPollUser = result.randomElement() {
							voteView.storageCurrentResultRating = currentRating
							voteView.storagePollUserId = randomPollUser.id
							voteView.storagePollUserName = randomPollUser.nickname
							
							self.present(voteView, animated: true, completion: nil)
						}
						
					})
					
				}
				
			} catch let error {
				self.alertCommand(title: "Ошибка", message: "неизвестная ошибка")
				print("alleventbutton error: \(error)")
			}
		}
		
//		print("allevents")
//		if let voteView = storyboard?.instantiateViewController(withIdentifier: "voteView") as? VoteViewController {
//
//			present(voteView, animated: true, completion: nil)
//		}
	}
	@IBAction func requestToAddNewSubGroupButtonTapped(_ sender: UIButton) {
		
//		var orgId1 = 0
//		var storageGroupId = 0
//		
//		currentGroupListResult.forEach { (result) in
//			orgId1 = result.organization.id
//			storageGroupId = result.id
//		}
		
//		gettingCurrentParentId(currentGroupId: storageGroupId) { [weak self] (currentParentId) in
//			print("coming gettingCurrentParentId in button")
//			guard let self = self else { return }
//
//			guard let groupName = self.groupName.text else { print("groupName error"); return }
//			guard let description1 = self.groupDescription.text else { print("descrip error"); return }
//			let groupRequestsFacade = GroupFacadeRequests()
//			groupRequestsFacade.getRequest(typeParams: .requestToCreateChildGroupByUser(organizationId: orgId1, parentGroupId: currentParentId, title: groupName, description: description1))
//		}
		
	}
	@IBAction func showSubGroupsButtonTapped(_ sender: UIButton) {
		
	}
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if currentEventList.isEmpty {
			return 1
		} else {
			return currentEventList.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if currentEventList.isEmpty {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "stubDetailViewCell", for: indexPath) as? StubDetailViewCell {
				
				return cell
			}
		} else {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "groupDetailCellId", for: indexPath) as? DetailTableViewCell {
				
				if let _ = currentEventList[indexPath.row].id {
					cell.textLabel?.text = "Новое событие"
				}
				
				return cell
			}
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if let voteView = storyboard?.instantiateViewController(withIdentifier: "voteView") as? VoteViewController {
//			print("currentEventList ID indexpath: \(String(describing: currentEventList[indexPath.row].id))")
//			voteView.eventId = currentEventList[indexPath.row].id
//			present(voteView, animated: true, completion: nil)
//		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if currentEventList.isEmpty {
			return 150
		} else {
			return 40
		}
	}
	
}
