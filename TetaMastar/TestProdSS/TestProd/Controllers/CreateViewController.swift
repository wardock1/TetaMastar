//
//  CreateViewController.swift
//  TestProd
//
//  Created by Developer on 17/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {
	
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var phoneTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var createButton: UIButton!
	
	let createService = CreateNewUser()
	let authController = Authentication()
	let requestsFacade = UserFacadeRequests()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfigButtons()
		nameTextField.delegate = self
		phoneTextField.delegate = self
		passwordTextField.delegate = self
	}
	
	deinit {
		print("createdVC deinited")
	}
	
	func setupConfigButtons() {
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		nameTextField.layer.cornerRadius = 5
		nameTextField.layer.masksToBounds = true
		nameTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		phoneTextField.layer.cornerRadius = 5
		phoneTextField.layer.masksToBounds = true
		phoneTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		passwordTextField.layer.cornerRadius = 5
		passwordTextField.layer.masksToBounds = true
		passwordTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
	
	func hideKeyboard() {
		nameTextField.resignFirstResponder()
		phoneTextField.resignFirstResponder()
		passwordTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	
	@IBAction func createTapped(_ sender: UIButton) {
		
		guard let phone = phoneTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { print("phone, password = nil, error"); return }
		
		if validate(password: password) {
			createService.createNewUser(login: phone, password: password) {[weak self] res in
				guard let self = self else { return }
				if res {
					self.authController.authenticationNewUserWithNotification(login: phone, password: password, completion: { (response) in
						if response == "ok" {
							DispatchQueue.main.async {
								if let enterCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "enterCondeVC") as? EnterCodeController {
									enterCodeVC.storageUserLogin = phone
									enterCodeVC.storageUserPassword = password
									enterCodeVC.storageUserNickName = name
									self.navigationController?.pushViewController(enterCodeVC, animated: true)
								}
							}
						}
					})
					
//					self.authController.authenticationNewUserWithSmsCode(login: phone, password: password, completion: {[weak self] (response) in
//						guard let self = self else { return }
//						if response == "ok" {
//							DispatchQueue.main.async {
//								if let enterCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "enterCondeVC") as? EnterCodeController {
//									enterCodeVC.storageUserLogin = phone
//									enterCodeVC.storageUserPassword = password
//									enterCodeVC.storageUserNickName = name
//									self.navigationController?.pushViewController(enterCodeVC, animated: true)
//								}
//							}
//						}
//					})
					
				}
			}
		}
	}
}

//extension AuthErrorCode {
//	var errorMessage: String {
//		switch self {
//		case .emailAlreadyInUse:
//			return "Email уже используется с другим аккаунтом"
//		case .userNotFound:
//			return "Пользователь не найден"
//		case .invalidEmail, .invalidSender, .invalidRecipientEmail:
//			return "Попробуйте еще раз ввести корреткный email"
//		case .networkError:
//			return "Попробуйте еще раз"
//		case .weakPassword:
//			return "Пароль слишком простой, так не пойдет"
//		case .wrongPassword:
//			return "Пароль был введен не правильно"
//		default:
//			return "Что-то пошло не так, сорян"
//		}
//	}
//}

extension UIViewController {
	//	func handleError(_ error: Error) {
	//		if let errorCode = AuthErrorCode(rawValue: error._code) {
	//			print(errorCode.errorMessage)
	//			let alert = UIAlertController(title: "Ошибка", message: errorCode.errorMessage, preferredStyle: .alert)
	//
	//			let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
	//
	//			alert.addAction(okAction)
	//
	//			self.present(alert, animated: true, completion: nil)
	//
	//		}
	//	}
	
	func alertCommand (title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(action)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func validate(password: String) -> Bool {
		var isUppercase = false
		var isLowerCase = false
		for char in password {
			if char.isUppercase {
				isUppercase = true
			}
			if char.isLowercase {
				isLowerCase = true
			}
		}
		return password.count >= 6 && isLowerCase && isUppercase
	}
	
}
