//
//  ProfileController.swift
//  TestProd
//
//  Created by Developer on 16/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Locksmith

protocol ProfileDateUpdatable {
	func updateProfileData()
}

class ProfileController: UIViewController {
	
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var secondNameLabel: UILabel!
	@IBOutlet weak var numberPhoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var aboutMeLabel: UITextView!
	@IBOutlet weak var moreInfo: UIButton!
	@IBOutlet weak var leaveProfileButton: UIButton!
	
	@IBOutlet weak var professionalismLabel: UILabel!
	@IBOutlet weak var disciplineLabel: UILabel!
	@IBOutlet weak var effenciencyLabel: UILabel!
	@IBOutlet weak var loyaltyLabel: UILabel!
	
	let userRequestFacade = UserFacadeRequests()
	
	let settingImage = UIImage(named: "settings")
	
	var userRatingList: UserRating!
	var userInfoList: User!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		moreInfo.setImage(settingImage, for: .normal)
		avatar.layer.cornerRadius = 0.5 * avatar.bounds.size.width
		gettingUserData()
		setDecorationButtons()
	}
	
	deinit {
		print("profile deinited")
	}
	
	func gettingUserData() {
		guard let userInfo = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { print("userInfo try error"); return }
		
		guard let userId = userInfo["userId"] as? Int else { print("userId try error"); return  }
		print("userId isisisiisis: \(userId)")
		fetchUserInfo(userId: userId)
	}
	
	func fetchUserInfo(userId: Int) {
		userRequestFacade.getRequest(typeParams: .getInfo(uid: userId))

		WebSocketNetworking.shared.socket.onData = { [weak self] data in
			print("fetchUserInfo here \(data)")
			guard let self = self else { print("error self fetchUserInfo "); return }
			
			do {
				let jsonResponse = try JSONDecoder().decode(NewUser.self, from: data)
				
				if jsonResponse.result.firstName == nil {
					self.nameLabel.text = jsonResponse.result.nickname
				} else {
					self.nameLabel.text = jsonResponse.result.firstName
				}
				
				if jsonResponse.result.lastName == nil {
					self.secondNameLabel.text = "Фамилия не указана"
				} else {
					self.secondNameLabel.text = jsonResponse.result.lastName
				}
				
				if jsonResponse.result.email == nil {
					self.emailLabel.text = "Почта не указана"
				} else {
					self.emailLabel.text = jsonResponse.result.email
				}
				
				if jsonResponse.result.aboutMe == nil {
					self.aboutMeLabel.text = "Информация о себе не указана"
				} else {
					self.aboutMeLabel.text = jsonResponse.result.aboutMe
				}
				
				self.numberPhoneLabel.text = jsonResponse.result.phone
				self.fetchUserAvatar(userId: userId)

				guard let professionalism = jsonResponse.result.score?.professionalism else { return }
				guard let discipline = jsonResponse.result.score?.discipline else { return }
				guard let effenciency = jsonResponse.result.score?.efficiency else { return }
				guard let loyalty = jsonResponse.result.score?.loyalty else { return }

				self.professionalismLabel.text = String(professionalism)
				self.disciplineLabel.text = String(discipline)
				self.effenciencyLabel.text = String(effenciency)
				self.loyaltyLabel.text = String(loyalty)

			} catch let error {
				print("fetchUserInfo error: \(error)")
			}
			
		}
	}
	
	func fetchUserAvatar(userId: Int) {
		userRequestFacade.getRequest(typeParams: .getUserAvatar(userId: userId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				print("gettingUserAvatar res")
				guard let result = jsonResponse?["result"] as? [String: Any] else {print("result error"); return }
				guard let content = result["content"] as? String else { print("error content"); return }
				guard let image = content.ConvertBase64StringToImage() else {print("error decodeData"); return }
				self.avatar.image = image
				
			} catch let error {
				print("fetchUserAvatar error: \(error)")
			}
		}
	}
	
	func getUserRatig() {
	}
	
	func setTitleEffenciency(discipline: Int?, efficiency: Int?, loyalty: Int?, professionalism: Int?) {
		DispatchQueue.main.async {
			if let discipline1 = discipline, let efficiency1 = efficiency, let loyalty1 = loyalty, let professionalism1 = professionalism {
				self.disciplineLabel.text = String(discipline1)
				self.effenciencyLabel.text = String(efficiency1)
				self.loyaltyLabel.text = String(loyalty1)
				self.professionalismLabel.text = String(professionalism1)
			}
		}
	}
	
	@IBAction func aboutButtonTapped(_ sender: UIButton) {
		if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as? EditingProfileViewController {
			destinationVC.profileDataUpdatebleDelegate = self
			destinationVC.storageName = nameLabel.text
			if secondNameLabel.text == "Фамилия не указана" {
				destinationVC.storageSecondName = "Фамилия не указана"
			} else {
				destinationVC.storageSecondName = secondNameLabel.text
			}
			if emailLabel.text == "Почта не указана" {
				destinationVC.storageEmail = "Почта не указана"
			} else {
				destinationVC.storageEmail = emailLabel.text
			}
			
			destinationVC.storageAvatar = avatar.image
			self.navigationController?.pushViewController(destinationVC, animated: true)
		}
		
	}
	
	@IBAction func leaveProfileButtonTapped(_ sender: UIButton) {
		UserDefaults.standard.setIsLoggedIn(value: false)
		do {
			try Locksmith.deleteDataForUserAccount(userAccount: "MyAccount")
		} catch {
			print("error when try delete data from LS")
		}
		print("userDef is false")
	}
	
	func setDecorationButtons() {
		leaveProfileButton.layer.cornerRadius = 14
		leaveProfileButton.layer.masksToBounds = true
		leaveProfileButton.layer.borderWidth = 1
		leaveProfileButton.backgroundColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
		leaveProfileButton.layer.borderColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
		leaveProfileButton.setTitle("Выйти из профиля", for: .normal)
	}
}

extension ProfileController: ProfileDateUpdatable {
	func updateProfileData() {
		gettingUserData()
	}
	
	
}
