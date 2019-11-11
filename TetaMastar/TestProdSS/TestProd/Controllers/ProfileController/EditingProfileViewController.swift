//
//  EditingProfileViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 08/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class EditingProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var secondNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var aboutMeTextField: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	
	var storageName: String?
	var storageSecondName: String?
	var storageBirthDay: Int?
	var storageEmail: String?
	var storageAboutMe: String?
	var storageAvatar: UIImage?
	
	var nameFieldChange = false
	var secondNameFieldChange = false
	var birthdayFieldChange = false
	var emailFieldChange = false
	var aboutMeFieldChange = false
	var avatarFieldChange = false
	
	var profileDataUpdatebleDelegate: ProfileDateUpdatable?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
		delegatingTextFields()
		chekingInfoAboutUser()
		nameTextField.text = storageName
		
		avatarImage.image = storageAvatar
		trackingTextFieldChage()
		setupDecorateButtons()
		
		avatarImage.layer.cornerRadius = 0.5 * avatarImage.bounds.size.width
		avatarImage.clipsToBounds = true
//		avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePicker)))
    }
	
	func chekingInfoAboutUser() {
		if storageSecondName == "Фамилия не указана" {
			secondNameTextField.placeholder = "Укажите фамилию"
		} else {
			secondNameTextField.text = storageSecondName
		}
		
		if storageEmail == "Почта не указана" {
			emailTextField.placeholder = "Укажите почту"
		} else {
			emailTextField.text = storageEmail
		}
	}
	
	deinit {
		print("EditingProfileViewController deinited")
	}
	
	func trackingTextFieldChage() {
		nameTextField.addTarget(self, action: #selector(nameTextFieldChange), for: .editingChanged)
		secondNameTextField.addTarget(self, action: #selector(secondNameTextFieldChange), for: .editingChanged)
//		birthdayTextField.addTarget(self, action: #selector(birthDayTextFieldChange), for: .editingChanged)
		emailTextField.addTarget(self, action: #selector(emailTextFieldChange), for: .editingChanged)
		aboutMeTextField.addTarget(self, action: #selector(aboutMeTextFieldChange), for: .editingChanged)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(avatarImageWasChanged))
		avatarImage.addGestureRecognizer(tap)
	}
	
	
	@objc func avatarImageWasChanged() {
		print("avatarImageWasChanged was end")
		handlePicker()
		avatarFieldChange = true
	}
	
	@objc func nameTextFieldChange() {
		print("editing was end")
		nameFieldChange = true
	}
	
	@objc func secondNameTextFieldChange() {
		print("secondNameTextFieldChange was end")
		secondNameFieldChange = true
	}
	
	@objc func birthDayTextFieldChange() {
		print("birthDayTextFieldChange was end")
		birthdayFieldChange = true
	}
	
	@objc func emailTextFieldChange() {
		print("emailTextFieldChange was end")
		emailFieldChange = true
	}
	
	@objc func aboutMeTextFieldChange() {
		print("aboutMeTextFieldChange was end")
		aboutMeFieldChange = true
	}
	
	@objc func avatarImageFieldChange() {
		print("avatarFieldChange was end")
		avatarFieldChange = true
	}
	
	@IBAction func saveButtonTapped(_ sender: UIButton) {
//		print(nameFieldChange)
//		print(secondNameFieldChange)
//		print(birthdayFieldChange)
//		print(emailFieldChange)
//		print(aboutMeFieldChange)
//		print(avatarFieldChange)
		banchRequest()
	}
	
	func delegatingTextFields() {
		nameTextField.delegate = self
		secondNameTextField.delegate = self
//		birthdayTextField.delegate = self
		emailTextField.delegate = self
		aboutMeTextField.delegate = self
	}
	
	func hideKeyboard() {
		nameTextField.resignFirstResponder()
		secondNameTextField.resignFirstResponder()
//		birthdayTextField.resignFirstResponder()
		emailTextField.resignFirstResponder()
		aboutMeTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	
	func setupDecorateButtons() {
		saveButton.layer.cornerRadius = 14
		saveButton.layer.masksToBounds = true
		saveButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
	}
	
	func banchRequest() {
		var param = [[String: Any]]()
		
		if nameFieldChange {
			guard let name = nameTextField.text else { return }
			let nameParam = paramSetFirstName(name: name)
			param.append(nameParam)
		}
		
		if secondNameFieldChange {
			guard let secondName = secondNameTextField.text else { return }
			let secondNameParam = paramSetLastName(lastName: secondName)
			param.append(secondNameParam)
		}
		
//		if birthdayFieldChange {
//			guard let birthDay = birthdayTextField.text else { return }
//			guard let birthDayInt = Int(birthDay) else { return }
//			let birthDayParam = paramSetBirthDay(birthDay: birthDayInt)
//			param.append(birthDayParam)
//		}
		
		if emailFieldChange {
			guard let email = emailTextField.text else { return }
			let emailParam = paramSetEmail(email: email)
			param.append(emailParam)
		}
		
		if aboutMeFieldChange {
			guard let aboutMe = aboutMeTextField.text else { return }
			let aboutMeParam = paramSetAboutMe(aboutMe: aboutMe)
			param.append(aboutMeParam)
		}
		
		if avatarFieldChange {
			guard let avatar = avatarImage.image else { return }
			let avatarParam = paramSetAvatar(newAvatar: avatar)
			param.append(avatarParam)
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
				self.profileDataUpdatebleDelegate?.updateProfileData()
				self.navigationController?.popToRootViewController(animated: true)
			} catch let error {
				print("setChangesToServer \(error)")
			}
		}
	}
	
	func paramSetAvatar(newAvatar: UIImage) -> [String: Any]  {
		
		let ww = newAvatar.jpegData(compressionQuality: 0.2)
		let ss = ww?.base64EncodedString()

		let param: [String: Any] = [
			"id": "user.SetAvatar",
			"jsonrpc": "2.0",
			"method": "user.SetAvatar",
			"params": [
				"avatar": ["content": ss]
			]
		]
		return param
	}
	
	func paramSetFirstName(name: String) -> [String: Any]  {
		let param: [String: Any] = [
			"id": "user.SetFirstName",
			"jsonrpc": "2.0",
			"method": "user.SetFirstName",
			"params": [
				"firstName": name
			]
		]
		return param
	}
	
	func paramSetNickName(nickName: String) -> [String: Any]  {
		let param: [String: Any] = [
			"id": "user.SetNickName",
			"jsonrpc": "2.0",
			"method": "user.SetNickName",
			"params": [
				"nickname": nickName
			]
		]
		return param
	}
	
	func paramSetLastName(lastName: String) -> [String: Any] {
		let param: [String: Any] = [
			"id": "user.SetLastName",
			"jsonrpc": "2.0",
			"method": "user.SetLastName",
			"params": [
				"lastName": lastName
			]
		]
		return param
	}
	
	func paramSetBirthDay(birthDay: Int) -> [String: Any] {
		let param: [String: Any] = [
			"id": "user.SetBDate",
			"jsonrpc": "2.0",
			"method": "user.SetBDate",
			"params": [
				"bDate": birthDay
			]
		]
		return param
	}
	
	func paramSetEmail(email: String) -> [String: Any] {
		let param: [String: Any] = [
			"id": "user.SetEmail",
			"jsonrpc": "2.0",
			"method": "user.SetEmail",
			"params": [
				"email": email
			]
		]
		return param
	}
	
	func paramSetAboutMe(aboutMe: String) -> [String: Any] {
		let param: [String: Any] = [
			"id": "user.SetAboutMe",
			"jsonrpc": "2.0",
			"method": "user.SetAboutMe",
			"params": [
				"aboutMe": aboutMe
			]
		]
		return param
	}
}

extension EditingProfileViewController {
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
			self.avatarImage.image = pickedImage
		}
	}
}
