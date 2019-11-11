//
//  SubGroupDetailViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 16/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class SubGroupDetailViewController: UIViewController {
	
	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var descriptionGroupLabel: UILabel!
	@IBOutlet weak var adminLabel: UILabel!
	@IBOutlet weak var startJoinRequestButton: UIButton!
	var currentSubGroup = [SingleGroupInfo.result]()
	var storageCurrentSubGroup = [SingleGroupInfo.result]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		currentSubGroup = storageCurrentSubGroup
		setInfoAboutGroup()
		setDecorationButtons()
	}
	
	private func setInfoAboutGroup() {
		currentSubGroup.forEach { (result) in
			groupNameLabel.text = "Название: \(result.title)"
			descriptionGroupLabel.text = "Описание: \(result.description)"
			gettingInfoAboutAdmin(userId: result.admin)
		}
	}
	
	func gettingInfoAboutAdmin(userId: Int) {
		let userRequestFacade = UserFacadeRequests()
		userRequestFacade.getRequest(typeParams: .getInfo(uid: userId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			
			do {
				let jsonResponse = try JSONDecoder().decode(NewUser.self, from: data)
				guard let adminName = jsonResponse.result.firstName ?? jsonResponse.result.nickname else { return }
				self.adminLabel.text = "Админ группы: \(adminName)"
				
			} catch let error {
				print("gettingInfoAboutGroupid \(error)")
			}
		}
	}
	
	@IBAction func startJoingRequestButtonTapped(_ sender: UIButton) {
		var groupId = 0
		currentSubGroup.forEach { (result) in
			groupId = result.id
		}
		
		let requestFacade = GroupFacadeRequests()
		requestFacade.getRequest(typeParams: .groupJoinRequestFromAnotherUser(groupId: groupId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			print("starjoing button subgroup COMING data")
			
			if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				print("jsonResponse startJoingRequest \(jsonResponse)")
				
				guard let resultError = jsonResponse["error"] as? [String: Any] else { print("error resultError"); return }
				guard let message = resultError["message"] as? String else { print("error message"); return }
				if message == "target person already in group" {
					self.alertCommand(title: "Ошибка", message: "Вы уже находитесь в этой группе")
					return
				}
			}
			
			self.alertCommand(title: "Принято", message: "Запрос на вступление отправлен")
		}
	}
	
	func setDecorationButtons() {
		startJoinRequestButton.layer.cornerRadius = 17
		startJoinRequestButton.layer.masksToBounds = true
		startJoinRequestButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
}
