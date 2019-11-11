//
//  LoginController.swift
//  TestProd
//
//  Created by Developer on 17/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var loginImage: UIImageView!
	
	private let authController = Authentication()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loginTextField.delegate = self
		passwordTextField.delegate = self
		setupConfigButtons()
		self.hideKeyboardWhenTappedAround()
	}
	
	deinit {
		print("login deinited")
	}
	
	@IBAction func loginTapped(_ sender: UIButton) {
		guard let login = loginTextField.text, let password = passwordTextField.text else { return }
		if validate(password: password) {
			
			authController.authenticationNewUserWithNotification(login: login, password: password) {[weak self] (response) in
				guard let self = self else { return }
				if response == "ok" {
					DispatchQueue.main.async {
						if let enterCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "enterCondeVC") as? EnterCodeController {
							enterCodeVC.storageUserLogin = login
							enterCodeVC.storageUserPassword = password
							self.navigationController?.pushViewController(enterCodeVC, animated: true)
						}

					}

				} else {
					print("authenticationNewUser error")
				}
			}
//			authController.authenticationNewUserWithSmsCode(login: login, password: password) {[weak self] (response) in
//				guard let self = self else { return }
//				if response == "ok" {
//					DispatchQueue.main.async {
//						if let enterCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "enterCondeVC") as? EnterCodeController {
//							enterCodeVC.storageUserLogin = login
//							enterCodeVC.storageUserPassword = password
//							self.navigationController?.pushViewController(enterCodeVC, animated: true)
//						}
//
//					}
//
//				} else {
//					print("authenticationNewUser error")
//				}
//			}
			
		} else {
			alertCommand(title: "", message: "Bad password")
		}
		
	}
	
	@IBAction func createTapped(_ sender: UIButton) {
		
		
	}
	
	func hideKeyboard() {
		loginTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
//	func authUser(login: String, password: String) {
//
//		guard let url = URL(string: "http://89.189.159.160:80/api/auth") else { return }
//
//		let parametrs: [String: Any] = [
//			"phone": login,
//			"password": password
//		]
//
//		var request = URLRequest(url: url)
//		request.httpMethod = "POST"
//		let jsonData = try! JSONSerialization.data(withJSONObject: parametrs, options: [])
//		request.httpBody = jsonData
//		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//			guard let data = data else { return }
//
//			do {
//				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//				guard let getData = jsonResponse as? [String: Any] else { return }
//
//				guard let token = getData["token"] as? String,
//					let id = getData["id"] as? Int else {
//						print("getData has error!!")
//						print("some error: \(String(describing: error))")
//						return
//				}
//				print("tokes is: \(token)")
//				print("id is: \(id)")
//				self.savingToken(token: token, id: id, login: login, password: password)
//				DispatchQueue.main.async {
//					self.dismiss(animated: true, completion: nil)
//				}
//
//			} catch let error {
//				print(error)
//			}
//		}
//		task.resume()
//	}
//
//	func savingToken(token: String, id: Int, login: String, password: String) {
//		do {
//			try Locksmith.updateData(data: ["token": token, "userId": id, "login": login, "password": password], forUserAccount: "MyAccount")
//		} catch {
//			print("unable to update token to LS")
//		}
//		loggedIn()
//	}
//
//	func loggedIn() {
//		UserDefaults.standard.setIsLoggedIn(value: true)
//		print("userDef is true")
//	}
	
	func setupConfigButtons() {
		loginButton.layer.cornerRadius = 17
		loginButton.layer.masksToBounds = true
		loginButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		loginTextField.layer.cornerRadius = 5
		loginTextField.layer.masksToBounds = true
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		loginTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
		passwordTextField.layer.cornerRadius = 5
		passwordTextField.layer.masksToBounds = true
		passwordTextField.layer.setGradienBorderForTextField(colors: bor, width: 1)
		
	}
}

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
