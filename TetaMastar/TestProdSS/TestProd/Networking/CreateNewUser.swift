//
//  CreateNewUser.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 27/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

class CreateNewUser {
	
	func createNewUser(login: String, password: String, completion: @escaping (Bool) -> Void) {
		
		guard let url = URL(string: "http://89.189.159.160:80/api/auth") else { return }
		
		let parameters: [String: Any] = [
			"id": "user.Create",
			"jsonrpc": "2.0",
			"method": "user.Create",
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
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				print("gettoken parse: \(String(describing: jsonResponse))")
				completion(true)
				
			} catch let error {
				completion(false)
				print("getToken error: \(error)")
			}
			
		}
		task.resume()
	}
//	func createNewUser(phone: String, password: String, name: String, completion: @escaping (Bool) -> Void) {
//
//		let url = URL(string: "http://89.189.159.160:80/api/user")!
//		var request = URLRequest(url: url)
//		request.httpMethod = "PUT"
//		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//		request.addValue("IOSDreamTeam", forHTTPHeaderField: "User-Agent")
//
//		let parameters: [String: Any] = [
//				"phone": phone,
//				"password": password
//		]
//
//		let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
//		request.httpBody = jsonData
//
//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//			guard let data = data, error == nil else {
//				return
//			}
//
//			do {
//				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//				guard let getData = jsonResponse as? [String: Any] else { return }
//				if let getId = getData["id"] as? Int {
//					print("getId from getData: \(getId)")
//					completion(true)
//				} else {
//					completion(false)
//				}
//
//				//name: dmg001, phone: +71231122333, pass, ID: 1
//				//name: dmg002, phone: +71231122444, pass, ID: 3
//				//name: dmg003, phone: +71231122555 ID: 4
//				//name: dmg004, +71231122666 ID: 12
//				//name: dmg66, +71231122777 ID:
//				//name: dmg008 ID
//
//				//dmg112, +71231133444 ID
//				//dmg113, +71231133555
//				//dmg221, +71232233444
//				//dmg222, +71232233555
//				//dmg223, +71232233666 ID
//
//				//jms001 +73451122333 ID
//				//jms002 +72341122444
//				//jms003 +72341122555
//				//jms004 +72341122666
//				//jms005 +72341122777
	
	//org ID: 10 Main Org By 11
//
//			} catch {
//				print("error in getData/jsonResponse")
//				completion(false)
//			}
//		}
//		task.resume()
//
//	}
}


//id:5
//date:1571664329
//title:"Bossy Org1"
//description:"Bossy Org1 Descr"
//director:7
