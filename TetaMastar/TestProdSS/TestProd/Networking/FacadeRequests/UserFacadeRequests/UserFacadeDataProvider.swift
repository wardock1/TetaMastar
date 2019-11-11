//
//  TestRequestDataProvider.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 09/09/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Locksmith

class UserFacadeDataProvider {
	
	
	public func requests(type: RequestTypeParams, setData: String?) -> [String: Any] {
		switch type {
		case .getInfo(let uid):
			return getInfoAboutUser(uid: uid)
		case .setAboutMe(let aboutMeText):
			return setAboutMe(aboutMeText: aboutMeText)
		case .setFirstName(let firstName):
			return setFirstName(firstName: firstName)
		case .setNickName(let nickName):
			return setNickName(nickName: nickName)
		case .findUser(let text):
			return findUser(text: text)
		case .getUserAvatar(let userId):
			return getUserAvatar(userId: userId)
		case .setEmail(let email):
			return setEmail(email: email)
		}
	}
	
	private func getInfoAboutUser(uid: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.Get",
			"jsonrpc": "2.0",
			"method": "user.Get",
			"params": [
				"uid": uid
			]
		]
		return parameters
	}
	
	private func setAboutMe(aboutMeText: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.SetAboutMe",
			"jsonrpc": "2.0",
			"method": "user.SetAboutMe",
			"params": [
				"aboutMe": aboutMeText
			]
		]
		return parameters
	}
	
	private func setFirstName(firstName: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.SetFirstName",
			"jsonrpc": "2.0",
			"method": "user.SetFirstName",
			"params": [
				"firstName": firstName
			]
		]
		return parameters
	}
	
	private func setNickName(nickName: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.SetNickName",
			"jsonrpc": "2.0",
			"method": "user.SetNickName",
			"params": [
				"nickname": nickName
			]
		]
		return parameters
	}
	
	private func setEmail(email: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.SetNickName",
			"jsonrpc": "2.0",
			"method": "user.SetNickName",
			"params": [
				"email": email
			]
		]
		return parameters
	}
	
	private func findUser(text: String) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.Find",
			"jsonrpc": "2.0",
			"method": "user.Find",
			"params": [
				"text": text
			]
		]
		return parameters
	}
	
	private func getUserAvatar(userId: Int) -> [String: Any] {
		
		let parameters: [String: Any] = [
			"id": "user.GetAvatar",
			"jsonrpc": "2.0",
			"method": "user.GetAvatar",
			"params": [
				"uid": userId
			]
		]
		return parameters
	}
}
