//
//  UserDefaultsExt.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 09/09/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import Foundation

extension UserDefaults {
	
	func setIsLoggedIn(value: Bool) {
		set(value, forKey: "isLoggedIn")
	}
	
	func isLoggedIn() -> Bool {
		return bool(forKey: "isLoggedIn")
	}
	
}
