//
//  CreateSubGroupController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 14/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Locksmith

class CreateSubGroupController: UIViewController, UITextFieldDelegate  {
	@IBOutlet weak var subGroupNameTextField: UITextField!
	@IBOutlet weak var subGroupDescriptionTextField: UITextField!
	@IBOutlet weak var requestButton: UIButton!
	
	var currentGroupListResult = [NewGroupListWithAvatar1.result]()
	var storageCurrentGroupListData = [NewGroupListWithAvatar1.result]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		currentGroupListResult = storageCurrentGroupListData
		setDecorationButtons()
		subGroupNameTextField.delegate = self
		subGroupDescriptionTextField.delegate = self
    }
	
	func gettingCurrentParentId(currentGroupId: Int, completion: @escaping (Int) -> ()) {
//		var parentGroupId = 0
		
		let groupRequestsFacade = GroupFacadeRequests()
		groupRequestsFacade.getRequest(typeParams: .getInfo(groupId: currentGroupId))
		
		WebSocketNetworking.shared.socket.onData = { data in
			print("coming gettingCurrentParentId")
			do {
				let jsonResponse = try JSONDecoder().decode(GroupInfoModel.self, from: data)
//				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				print("jsonJSON: \(jsonResponse)")
				
				if let parentId = jsonResponse.result?.id {
					completion(parentId)
				}
				
			} catch let error {
				print("gettingCurrentParentId error: \(error)")
			}
			
			
			
		}
	}
	
	@IBAction func requestButtonTapped(_ sender: UIButton) {
		
		var orgId5 = 0
		var storageGroupId5 = 0
		var directorParentGroupId = 0
		
		currentGroupListResult.forEach { (result) in
			orgId5 = result.organization.id
			storageGroupId5 = result.id
			directorParentGroupId = result.admin
		}
		
		gettingCurrentParentId(currentGroupId: storageGroupId5, completion: { [weak self] (data) in
			print("coming gettingCurrentParentId in button")
			guard let self = self else { return }
			
			guard let groupName = self.subGroupNameTextField.text else { print("groupName error"); return }
			guard let description1 = self.subGroupDescriptionTextField.text else { print("descrip error"); return }
			let groupRequestsFacade = GroupFacadeRequests()
			
			var userId = 0
			guard let ss = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { return }
			if let id = ss["userId"] as? Int {
				userId = id
			}
			
			if userId == directorParentGroupId {
				groupRequestsFacade.getRequest(typeParams: .createChildGroupByAdmin(organizationId: orgId5, parentGroupId: data, title: groupName, description: description1))
			} else {
				groupRequestsFacade.getRequest(typeParams: .requestToCreateChildGroupByUser(organizationId: orgId5, parentGroupId: data, title: groupName, description: description1))
			}
			
			
			WebSocketNetworking.shared.socket.onData = {[weak self] data in
				guard let self = self else { return }
				print("finnally data gettinCurrentParent")
				do {
					let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
					self.navigationController?.popToRootViewController(animated: true)
					print("finnally data \(jsonResponse)")
				} catch {
					print("finnally data gettinCurrentParent")
				}
			}
		})
	}
	
	func setDecorationButtons() {
		requestButton.layer.cornerRadius = 17
		requestButton.layer.masksToBounds = true
		requestButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
	
	func hideKeyboard() {
		subGroupNameTextField.resignFirstResponder()
		subGroupNameTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	
}
