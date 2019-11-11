//
//  Authentication.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 27/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Locksmith

class Authentication {
	
	private let userAuthFacade = UserAuthRequestsFacade()
	
	func authenticationNewUserWithNotification(login: String, password: String, completion: @escaping (String) -> Void) {

		guard let url = URL(string: "http://89.189.159.160:80/api/auth") else { return }

		let parameters: [String: Any] = [
			"id": "code.SendNotification",
			"jsonrpc": "2.0",
			"method": "code.SendNotification",
			"params": [
				"phone": login,
				"password": password
			]
		]


		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.allHTTPHeaderFields = ["Content-Type": "application/json;charset=utf-8", "User-Agent": "IOSDreamTeam"]
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData

		let task = URLSession.shared.dataTask(with: request) { data, response, error in

			guard let data = data else { return }

			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				print("json: \(jsonResponse)")
				completion("ok")
				
			} catch let error {
				print(error)
			}
		}
		task.resume()
	}
	
	func authenticationNewUserWithSmsCode(login: String, password: String, completion: @escaping (String) -> Void) {
		
		guard let url = URL(string: "http://89.189.159.160:80/api/auth") else { return }
		
		let parameters: [String: Any] = [
			"id": "code.SendSms",
			"jsonrpc": "2.0",
			"method": "code.SendSms",
			"params": [
				"phone": login,
				"password": password
			]
		]
		
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.allHTTPHeaderFields = ["Content-Type": "application/json;charset=utf-8", "User-Agent": "IOSDreamTeam"]
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let data = data else { return }
			
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				print("json: \(jsonResponse)")
				completion("ok")
				
			} catch let error {
				print(error)
			}
		}
		task.resume()
	}
	
	func authenticationGetToken(login: String, code: Int, completion: @escaping (GetTokenModel) -> Void) {
		
		guard let url = URL(string: "http://89.189.159.160:9007/auth") else { return }
		
		let parameters: [String: Any] = [
			"id": "token.Get",
			"jsonrpc": "2.0",
			"method": "token.Get",
			"params": [
				"phone": login,
				"code": code
			]
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.allHTTPHeaderFields = ["Content-Type": "application/json;charset=utf-8", "User-Agent": "IOSDreamTeam"]
		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			guard let data = data else { return }
			
			do {
				let jsonResponse = try JSONDecoder().decode(GetTokenModel.self, from: data)
				print("gettoken parse: \(jsonResponse)")
				completion(jsonResponse)
				
			} catch let error {
				print("getToken error: \(error)")
			}
			
		}
		task.resume()
	}
//
//	func authenticationAfterCreatedNewUser(login: String, password: String, completion: @escaping (Bool) -> ()) {
//
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
//		request.addValue("IOSDreamTeam", forHTTPHeaderField: "User-Agent")
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
//
//				self.savingDataToLockSmith(token: token, id: id, login: login, password: password)
//				WebSocketNetworking.shared.startConnectingToWS(token: token, completion: { (result) in
//					if result {
//						completion(true)
//					} else {
//						completion(false)
//					}
//				})
//			} catch let error {
//				print(error)
//			}
//		}
//		task.resume()
//	}
	
//	private func savingDataToLockSmith(token: String, id: Int, login: String, password: String) {
//		do {
//			try Locksmith.updateData(data: ["token": token, "userId": id, "login": login, "password": password], forUserAccount: "MyAccount")
//			print("savingDataTO LS ok is true")
//		} catch {
//			print("unable to update token to LS")
//		}
//		loggedIn()
//	}
//	
//	private func loggedIn() {
//		UserDefaults.standard.setIsLoggedIn(value: true)
//		print("userDef is true")
//	}
	
//	func authenticationSavedUser(login: String, password: String) {
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
//				self.saveToken()
//
//			} catch let error {
//				print(error)
//			}
//		}
//		task.resume()
//	}
//
//	private func saveToken() {
//
//	}
	
}
