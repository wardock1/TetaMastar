//
//  LockSmithObject.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 26/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation
import Locksmith

class LockSmithObject {
	
	
	func savingDataToLockSmith(token: String, id: Int, login: String, password: String, tokenExp: Date) {
		do {
			try Locksmith.updateData(data: ["token": token, "userId": id, "login": login, "password": password, "tokenExp": tokenExp], forUserAccount: "MyAccount")
			print("savingDataTO LS ok is true")
		} catch {
			print("unable to update token to LS")
		}
		loggedIn()
	}
	
	private func loggedIn() {
		UserDefaults.standard.setIsLoggedIn(value: true)
		print("userDef is true")
	}
	
	func checkingTokenLife() -> Date? {
		guard let userData = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { return nil}
			if let tokenExp = userData["tokenExp"] as? Date {
				print("tokenexp: \(tokenExp)")
				return tokenExp
			}
		return nil
	}
	
}
