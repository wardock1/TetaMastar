//
//  AddNewUserViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 29/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class AddNewUserViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var secondNameTextField: UITextField!
	@IBOutlet weak var findUserButton: UIButton!
	@IBOutlet weak var inviteUserButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	let userRequestsFacade = UserFacadeRequests()
	weak var updateMemberListDelegate: MemberListUpdateble?
	
	var userList = [User]() {
		didSet {
			print("userList in AddNewUser: \(userList)")
			
//			alertCommand(title: "", message: "User has been find and invite")
		}
	}
	
	var newUserList = [FindedUsers.result]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	var currentGroupId: Int?
	var storageCurrentIdGroup: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDecorationButtons()
		delegating()
		tableView.separatorColor = .clear
		nameTextField.delegate = self
		secondNameTextField.delegate = self
		self.hideKeyboardWhenTappedAround()
		
		currentGroupId = storageCurrentIdGroup
	}
	
	deinit {
		print("AddNewUser deinited")
	}
	
	func setDecorationButtons() {
		findUserButton.layer.cornerRadius = 17
		findUserButton.layer.masksToBounds = true
		findUserButton.layer.borderWidth = 1
		findUserButton.backgroundColor = .clear
		findUserButton.layer.borderColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
		findUserButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		inviteUserButton.layer.cornerRadius = 17
		inviteUserButton.layer.masksToBounds = true
		inviteUserButton.backgroundColor = .clear
		inviteUserButton.layer.borderWidth = 1
		inviteUserButton.layer.borderColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
	}
	
	func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	@IBAction func findUserButtonTapped(_ sender: UIButton) {
		guard let textFindUser = nameTextField.text else { return }
		newUserList.removeAll()
		userRequestsFacade.getRequest(typeParams: .findUser(text: textFindUser))
		
		WebSocketNetworking.shared.socket.onData = { (data: Data) in
			self.testingParse(data: data)
			print("FIND NEW USER VC SHIT")
		}
	}
	
	private func testingParse(data: Data) {
		do {
			let jsonResponse = try JSONDecoder().decode(FindedUsers.self, from: data)
			print("jsonResponse parse: \(jsonResponse)")
//			newUserList.append(jsonResponse)
			
			jsonResponse.result.forEach { (result) in
				newUserList.append(result)
			}
			
		} catch let err {
			print("error rorr \(err)")
			if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				print("json is: \(json)")
				if let errorName = json["error"] as? [String: Any] {
					print("errorName: \(errorName)")
					guard let message = errorName["message"] as? String else { print("message error failure"); return }
					if message == "user not found" {
						self.alertCommand(title: "Ошибка", message: "Пользователь с такими данными не найден")
					}
				}
			}
		}
	}
	
	func hideKeyboard() {
		nameTextField.resignFirstResponder()
		secondNameTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	
	
	@IBAction func inviteUserButtonTapped(_ sender: UIButton) {
		guard let currentGroupId = currentGroupId else { return }
		var findedUser = 0
		
		if let currentIndex = tableView.indexPathForSelectedRow {
			let currentIndex = newUserList[currentIndex.row]
			guard let currentUserId = currentIndex.id else { return }
			findedUser = currentUserId
		}
		
		print("INVIRTED USER USER ID: \(findedUser)")
		let groupRequestFacade = GroupFacadeRequests()
		groupRequestFacade.getRequest(typeParams: .addNewUser(groupId: currentGroupId, targetPersonId: findedUser))

		WebSocketNetworking.shared.socket.onData = { (data: Data) in
			print("AddNewUser VC SHIT")
					do {
						if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
							print(jsonResponse)
						}
					} catch {
						print("error didReceiveData")
					}
		}
		
		updateMemberListDelegate?.updateMemberListWithNewUsers()
		self.navigationController?.popViewController(animated: true)
	}
	}

extension AddNewUserViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newUserList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "addNewUserCell", for: indexPath) as? AddNewUserTableViewCell {
			cell.nameLabel.text = newUserList[indexPath.row].nickname
			
			
			return cell
		}
		return UITableViewCell()
	}
	
	
	
}
