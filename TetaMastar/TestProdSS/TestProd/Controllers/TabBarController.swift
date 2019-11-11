//
//  TabBarController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Locksmith

class TabBarController: UITabBarController {
	
	let authentication = Authentication()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if isLoggedIn() {
			checkingTokenLife()
		} else {
			perform(#selector(showingLoggingView), with: nil, afterDelay: 0.01)
		}
		
//		if  let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[3] as? UITabBarItem {
//			tabBarItem.isEnabled = false
//		}
	}
	
	func isLoggedIn() -> Bool {
		return UserDefaults.standard.isLoggedIn()
	}
	
	func checkingTokenLife() {
		let lockSmithVC = LockSmithObject()
		if let currentTokenDateExpire = lockSmithVC.checkingTokenLife() {
			
			let currentDate = Date()
			print("DATE IS: \(currentDate)")
			
			if currentDate < currentTokenDateExpire {
				gettingTokenAndConnectToWS()
			}  else {
				perform(#selector(showingLoggingView), with: nil, afterDelay: 0.01)
			}
		} else {
			perform(#selector(showingLoggingView), with: nil, afterDelay: 0.01)
		}
		
	}
	
	func gettingTokenAndConnectToWS() {
		
		if let tokenFromLS = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") {
			if let token = tokenFromLS["token"] as? String {
				WebSocketNetworking.shared.startConnectingToWS(token: token) { (bool) in
					print("gettingTokenAndConnectToWS bool is: \(bool)")
				}
			}
		} else {
			print("error when getting token from LS")
			DispatchQueue.main.async {
				self.alertCommand(title: "Произошла ошибка", message: "Для корректной работы, приложение необходимо перезагрузить")
			}
		}
	}
	
	@objc func showingLoggingView() {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? LoginNavigationController {
			present(vc, animated: true, completion: nil)
		}
		
	}
	
	deinit {
		print("deinited tabbar")
	}
}
