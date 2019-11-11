//
//  EnterCodeController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 25/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class EnterCodeController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var codeTextField: UITextField!
	@IBOutlet weak var enterButton: UIButton!
	
	private let userAuthRequest = Authentication()
	private var userLogin: String?
	private var userPassword: String?
	private var userNickName: String?
	var storageUserLogin: String?
	var storageUserPassword: String?
	var storageUserNickName: String?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfigButtons()
		userLogin = storageUserLogin
		userPassword = storageUserPassword
		userNickName = storageUserNickName
	}
	
	deinit {
		print("enterCode deinited")
	}
	
	@IBAction func enterButtonTapped(_ sender: UIButton) {
		guard let login = userLogin else { return }
		guard let codeTF = codeTextField.text else { return }
		guard let code = Int(codeTF) else { return }
		
		userAuthRequest.authenticationGetToken(login: login, code: code) { [weak self] (response) in
			guard let self = self else { return }
			
			if let token = response.result?.token, let userId = response.result?.userID, let password = self.userPassword, let tokenExp = response.result?.exp, let nickName = self.userNickName {
				let timeInterval = Double(tokenExp)
				let myNSDate = Date(timeIntervalSince1970: timeInterval)
				print("myNSDate: \(myNSDate)")
				let lockSmith = LockSmithObject()
				lockSmith.savingDataToLockSmith(token: token, id: userId, login: login, password: password, tokenExp: myNSDate)
				
				WebSocketNetworking.shared.startConnectingToWS(token: token, completion: {[weak self] (response) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						self.setUserNickName(login: nickName, completion: {
							self.dismiss(animated: true, completion: nil)
						})
					}
				})
			} else {
				guard let token = response.result?.token else { return }
				guard let userId = response.result?.userID else { return }
				guard let tokenExp = response.result?.exp else { return }
				guard let password = self.userPassword else { return }
				let timeInterval = Double(tokenExp)
				let myNSDate = Date(timeIntervalSince1970: timeInterval)
				print("myNSDate: \(myNSDate)")
				
				let lockSmith = LockSmithObject()
				lockSmith.savingDataToLockSmith(token: token, id: userId, login: login, password: password, tokenExp: myNSDate)
				
				WebSocketNetworking.shared.startConnectingToWS(token: token, completion: {[weak self] (response) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						self.dismiss(animated: true, completion: nil)
					}
				})
				
			}
			
		}
	}
	
	func setUserNickName(login: String, completion: @escaping () -> Void) {
		let userFacade = UserFacadeRequests()
		
		userFacade.getRequest(typeParams: .setNickName(nickName: login))
		WebSocketNetworking.shared.socket.onData = { data in
			if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
				print("jsonUserNick response: \(jsonResponse)")
				completion()
			}
		}
	}
	
	func hideKeyboard() {
		enterButton.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	
	func setupConfigButtons() {
		enterButton.layer.cornerRadius = 14
		enterButton.layer.masksToBounds = true
		enterButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
	}
}
