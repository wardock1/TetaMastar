//
//  OrganizationViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 05/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Locksmith

class OrganizationViewController: UIViewController {

	@IBOutlet weak var orgAvatar: UIImageView!
	@IBOutlet weak var orgName: UILabel!
	@IBOutlet weak var orgDescription: UILabel!
	@IBOutlet weak var orgDirector: UILabel!
	@IBOutlet weak var orgCreateData: UILabel!
	@IBOutlet weak var createMainGroupButton: UIButton!
	@IBOutlet weak var startVote: UIButton!
	@IBOutlet weak var orgMoreDetailButton: UIButton!
	@IBOutlet weak var noStatisticImage: UIImageView!
	
	let tableView = UITableView()
	var selectedButton = UIButton()
	
	let orgRequestsFacade = OrganizationRequestsFacade()
	let userRequestsFacade = UserFacadeRequests()
	var orgId: Int? {
		didSet {
			gettingDataAboutOrg()
		}
	}
	var storageOrgId: Int?
	var storageDirectorId: Int?
	let transparentView = UIView()
	
	var storageToEditOrgName: String?
	var storageToEditOrgDescription: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		orgId = storageOrgId
		setupConfigButtons()
		setupConfigLabel()
		
    }
	
	func addTransparentView(frames: CGRect) {
		let window = UIApplication.shared.keyWindow
		transparentView.frame = window?.frame ?? self.view.frame
		self.view.addSubview(transparentView)
		
		tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: -250, height: 0)
		self.view.addSubview(tableView)
		tableView.layer.cornerRadius = 5
		
		transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
		transparentView.addGestureRecognizer(tapGesture)
		transparentView.alpha = 0
		UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
			self.transparentView.alpha = 0.5
			self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: -250, height: 200)
		}, completion: nil)
	}
	
	@objc func removeTransparentView() {
		let frames = selectedButton.frame
		UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
			self.transparentView.alpha = 0
			self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
		}, completion: nil)
	}
	
	private func gettingDataAboutOrg() {
		guard let currentOrgId = orgId else { return }
		print("ORG ID: \(currentOrgId)")
		orgRequestsFacade.getRequest(typeParams: .orgGet(orgId: currentOrgId))
		
		let dispatchQueue = DispatchQueue(label: "taskQueueInOrgByUserInfo")
		let dispatchSemaphore = DispatchSemaphore(value: 0)
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			do {
				let jsonResponse = try JSONDecoder().decode(GetInfoAboutOrg.self, from: data)
				print("gettingDataAboutOrg gettingDataAboutOrg gettingDataAboutOrg ")
				self.storageDirectorId = jsonResponse.result.director
				let dateFromServer = Double(jsonResponse.result.date)
				
				let date = Date(timeIntervalSince1970: dateFromServer)
				let dateFormatter = DateFormatter()
				dateFormatter.dateStyle = DateFormatter.Style.medium
				dateFormatter.dateFormat = "yyyy-MM-dd"
				dateFormatter.timeZone = .current
				let localDate = dateFormatter.string(from: date)
				self.orgCreateData.text = " Дата создания: \(localDate)"
				
				self.orgName.text = " Название проекта: \(jsonResponse.result.title)"
				self.storageToEditOrgName = jsonResponse.result.title
				self.orgDescription.text = " Описание проекта: \(jsonResponse.result.description)"
				self.storageToEditOrgDescription = jsonResponse.result.description
				
				dispatchQueue.async {
					self.parseGetInfoAboutUser(userId: jsonResponse.result.director, completion: {[weak self] (userInfo) in
						guard let self = self else { return }
						guard let directorName = userInfo.result.firstName ?? userInfo.result.nickname else { return }
						self.orgDirector.text = " Директор: \(directorName)"
						
						dispatchSemaphore.signal()
					})
					dispatchSemaphore.wait()
				}
				
				
				
				
				
			} catch let error {
				print("eror gettingDataAbout Org: \(error)")
			}
		}
	}
	
	func parseGetInfoAboutUser(userId: Int, completion: @escaping (NewUser) -> Void) {
		
		userRequestsFacade.getRequest(typeParams: .getInfo(uid: userId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			do {
				let jsonResponse = try JSONDecoder().decode(NewUser.self, from: data)
				self.gettingOrgAvatar()
				completion(jsonResponse)
				
			} catch let error {
				print("eror parseGetInfoAboutUser: \(error)")
			}
		}
	}
	
	func gettingOrgAvatar() {
		guard let currentOrgId = orgId else { return }
		orgRequestsFacade.getRequest(typeParams: .orgGetAvatar(orgId: currentOrgId))
		
		WebSocketNetworking.shared.socket.onData = { data in
			
			print("gettingOrgAvatar answer")
			do {
			let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
					guard let result = jsonResponse?["result"] as? [String: Any] else {print("error content"); return }
					guard let content = result["content"] as? String else { print("error content"); return }
				
					guard let decodeData = Data(base64Encoded: content, options: .ignoreUnknownCharacters) else {print("error decodeData"); return }
					guard let image = UIImage(data: decodeData) else { return }
				self.orgAvatar.image = image
//					completion(image)
				
			} catch let error {
				print("eror parseGetInfoAboutUser: \(error)")
			}
		}
	}
	
	@IBAction func orgMoreDetailButtonTapped(_ sender: UIButton) {
		guard let userInfo = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { print("userInfo try error"); return }
		guard let userId = userInfo["userId"] as? Int else { print("userId try error"); return  }
		print("userId isisisiisis: \(userId)")
		
		if storageDirectorId == userId {
			if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "editingOrg") as? EditingOrganizationViewController {
				guard let orgName = storageToEditOrgName, let orgDescription = storageToEditOrgDescription, let oid = orgId else { return }
				destinationVC.storageOrgId = oid
				destinationVC.storageOrgName = orgName
				destinationVC.storageOrgDescription = orgDescription
				destinationVC.storageOrgAvatar = orgAvatar.image
				self.navigationController?.pushViewController(destinationVC, animated: true)
			}
		} else {
			self.alertCommand(title: "Ошибка", message: "Только администратор может менять данные проекта")
		}
		
	}
	
	func gettingDirectorId() {
		
	}
	
	@IBAction func createMainGroupButtonTapped(_ sender: UIButton) {
		guard let oid = orgId else { return }
		
		if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "addNewGroup") as? AddNewGroupController {
			destinationVC.storageOrgId = oid
			self.navigationController?.pushViewController(destinationVC, animated: true)
		}
	}
	
	@IBAction func startVoteButtonTapped(_ sender: UIButton) {
		guard let oid = orgId else { return }
		orgRequestsFacade.getRequest(typeParams: .orgEnableRating(orgId: oid))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			print("startVoteButtonTapped answer")
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				print("jsonResponse startVoteButtonTapped \(String(describing: jsonResponse))")
				DispatchQueue.main.async {
					self.alertCommand(title: "", message: "Еженедельное голосование в проекте включено")
				}
				
			} catch let error {
				print("eror parseGetInfoAboutUser: \(error)")
			}
		}
	}
	
	func setupConfigButtons() {
		createMainGroupButton.layer.cornerRadius = 17
		createMainGroupButton.layer.masksToBounds = true
		createMainGroupButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		startVote.layer.cornerRadius = 17
		startVote.layer.masksToBounds = true
		startVote.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
	
	func setupConfigLabel() {
		orgAvatar.layer.cornerRadius = 0.5 * orgAvatar.bounds.size.width
		
		orgName.layer.cornerRadius = 5
		orgName.layer.masksToBounds = true
		orgName.backgroundColor = .clear
		orgName.layer.borderWidth = 1
		orgName.layer.borderColor = #colorLiteral(red: 0.255461961, green: 0.6874576807, blue: 0.7305728197, alpha: 1)
		orgName.textColor = #colorLiteral(red: 0.1221192852, green: 0.3360264405, blue: 0.3596376991, alpha: 1)
		
		orgDescription.layer.cornerRadius = 5
		orgDescription.layer.masksToBounds = true
		orgDescription.backgroundColor = .clear
		orgDescription.layer.borderWidth = 1
		orgDescription.layer.borderColor = #colorLiteral(red: 0.3037544795, green: 0.5918373426, blue: 0.7305728197, alpha: 1)
		orgDescription.textColor = #colorLiteral(red: 0.1221192852, green: 0.3360264405, blue: 0.3596376991, alpha: 1)
		
		orgDirector.layer.cornerRadius = 5
		orgDirector.layer.masksToBounds = true
		orgDirector.backgroundColor = .clear
		orgDirector.layer.borderWidth = 1
		orgDirector.layer.borderColor = #colorLiteral(red: 0.2509736133, green: 0.7305728197, blue: 0.6408710318, alpha: 1)
		orgDirector.textColor = #colorLiteral(red: 0.1221192852, green: 0.3360264405, blue: 0.3596376991, alpha: 1)
		
		orgCreateData.layer.cornerRadius = 5
		orgCreateData.layer.masksToBounds = true
		orgCreateData.backgroundColor = .clear
		orgCreateData.layer.borderWidth = 1
		orgCreateData.layer.borderColor = #colorLiteral(red: 0.3645804213, green: 0.6098836298, blue: 0.7305728197, alpha: 1)
		orgCreateData.textColor = #colorLiteral(red: 0.1221192852, green: 0.3360264405, blue: 0.3596376991, alpha: 1)
		
		noStatisticImage.layer.cornerRadius = 5
		noStatisticImage.layer.masksToBounds = true
		noStatisticImage.backgroundColor = .clear
		noStatisticImage.layer.borderWidth = 1
		noStatisticImage.layer.borderColor = #colorLiteral(red: 0.3645804213, green: 0.6098836298, blue: 0.7305728197, alpha: 1)
	}

}
