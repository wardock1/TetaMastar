//
//  EditingOrganizationViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 10/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class EditingOrganizationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var orgAvatarImage: UIImageView!
	@IBOutlet weak var orgNameTextField: UITextField!
	@IBOutlet weak var orgDescriptionTextField: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	
	
	var orgAvatarChanged = false
	var orgNameFieldChanged = false
	var orgDescriptionFieldChanged = false
	
	var storageOrgId: Int?
	var storageOrgName: String?
	var storageOrgDescription: String?
	var storageOrgAvatar: UIImage?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		chekingInfoAboutOrg()
		trackingTextFieldChage()
		setupDecorateButtons()
		delegating()
    }
	
	func chekingInfoAboutOrg() {
		orgNameTextField.text = storageOrgName
		orgDescriptionTextField.text = storageOrgDescription
		orgAvatarImage.image = storageOrgAvatar
	}
	
	@IBAction func saveButtonTapped(_ sender: UIButton) {
		banchRequest()
	}
	
	func trackingTextFieldChage() {
		orgNameTextField.addTarget(self, action: #selector(orgNameTextFieldChange), for: .editingChanged)
		orgDescriptionTextField.addTarget(self, action: #selector(orgDescriptionTextFieldChange), for: .editingChanged)
		let tap = UITapGestureRecognizer(target: self, action: #selector(avatarImageWasChanged))
		orgAvatarImage.addGestureRecognizer(tap)
	}
	
	@objc func orgNameTextFieldChange() {
		orgNameFieldChanged = true
	}
	@objc func orgDescriptionTextFieldChange() {
		orgDescriptionFieldChanged = true
	}
	
	@objc func avatarImageWasChanged() {
		handlePicker()
		orgAvatarChanged = true
	}
	
	func banchRequest() {
		guard let oid = storageOrgId else { return }
		var param = [[String: Any]]()
		
		if orgNameFieldChanged {
			guard let orgName = orgNameTextField.text else { return }
			let orgNameParam = paramSetTitle(orgName: orgName, oid: oid)
			param.append(orgNameParam)
		}
		
		if orgDescriptionFieldChanged {
			guard let orgDescription = orgDescriptionTextField.text else { return }
			let orgDescriptionParam = paramSetDescription(description: orgDescription, oid: oid)
			param.append(orgDescriptionParam)
		}
		
		if orgAvatarChanged {
			guard let newOrgAvatar = orgAvatarImage.image else { return }
			let newOrgAva = paramSetAvatar(newAvatar: newOrgAvatar, oid: oid)
			param.append(newOrgAva)
		}
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
			WebSocketNetworking.shared.socket.write(data: jsonData)
		} catch {
			print("error catch")
		}
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				print("jsonResont banchRequest: \(jsonResponse)")
//				self.navigationController?.popViewController(animated: true)
				self.navigationController?.popToRootViewController(animated: true)
			} catch let error {
				print("setChangesToServer \(error)")
			}
		}
	}
	
	func paramSetAvatar(newAvatar: UIImage, oid: Int) -> [String: Any]  {
		
		let ww = newAvatar.jpegData(compressionQuality: 0.2)
		let ss = ww?.base64EncodedString()
		
		let param: [String: Any] = [
			"id": "organization.SetAvatar",
			"jsonrpc": "2.0",
			"method": "organization.SetAvatar",
			"params": [
				"oid": oid,
				"avatar": ["content": ss]
			]
		]
		return param
	}
	
	func paramSetTitle(orgName: String, oid: Int) -> [String: Any]  {
		let param: [String: Any] = [
			"id": "organization.SetTitle",
			"jsonrpc": "2.0",
			"method": "organization.SetTitle",
			"params": [
				"oid": oid,
				"title": orgName
			]
		]
		return param
	}
	
	func paramSetDescription(description: String, oid: Int) -> [String: Any]  {
		let param: [String: Any] = [
			"id": "organization.SetDescription",
			"jsonrpc": "2.0",
			"method": "organization.SetDescription",
			"params": [
				"oid": oid,
				"description": description
			]
		]
		return param
	}
	
	func setupDecorateButtons() {
		orgAvatarImage.layer.cornerRadius = 0.5 * orgAvatarImage.bounds.size.width
		
		saveButton.layer.cornerRadius = 14
		saveButton.layer.masksToBounds = true
		saveButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
	}
	
	func delegating() {
		orgNameTextField.delegate = self
		orgDescriptionTextField.delegate = self
	}
	
	func hideKeyboard() {
		orgNameTextField.resignFirstResponder()
		orgDescriptionTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
}

extension EditingOrganizationViewController {
	@objc func handlePicker () {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
		
	}
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			return
		}
		dismiss(animated: true) {
			self.orgAvatarImage.image = pickedImage
		}
	}
}
