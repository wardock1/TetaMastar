//
//  MembersControllerView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 22/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol MemberListUpdateble: class {
	func updateMemberListWithNewUsers()
}

struct MembersList {
	let name: String
	let secondName: String
	let avatar: UIImage?
}

class MembersControllerView: UIViewController, UISearchBarDelegate {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var storageIdGroup: Int?
	var storageEventID: String?
	
	var newMemberList = [NewMembersInGroup.result]()
	var modelMemberList = [modelMembersInGroup.result.community.members]()
	
	var membersListData = [MembersList]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	let vc = DetailViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegating()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
		tableView.separatorStyle = .none
		gettingMembersInGroup()
		self.hideKeyboardWhenTappedAround()
	}
	
	func gettingMembersInGroup() {
		guard let groupId = storageIdGroup else {return}
		
		let facade = GroupFacadeRequests()
		facade.getRequest(typeParams: .getInfo(groupId: groupId))
		
		WebSocketNetworking.shared.socket.onData = { (data: Data) in
			self.testingParse(data: data)
			print("MEMBERSCONTROLLER SHIT")
		}
	}
	
	private func testingParse(data: Data) {
		do {
			let jsonResponse = try JSONDecoder().decode(modelMembersInGroup.self, from: data)
			print("jsonResponse parse: \(jsonResponse)")
			modelMemberList = jsonResponse.result.community.members
			
			let dispatchQueue = DispatchQueue(label: "taskQueueMemberAvatar")
			let dispatchSemaphore = DispatchSemaphore(value: 0)
			
			dispatchQueue.async {
				jsonResponse.result.community.members.forEach({[weak self] (result) in
					guard let self = self else { return }
					guard let uid = result.id else { return }
					
					self.gettingMembersAvatar(uid: uid, completion: {[weak self] (resultFromAvatar) in
						guard let self = self else { return }
						
						if resultFromAvatar == nil {
							let standartImage = UIImage(named: "avatar")
							let memberInfo = MembersList(name: result.firstName ?? result.nickname, secondName: result.lastName ?? "", avatar: standartImage)
							self.membersListData.append(memberInfo)
						} else {
							let memberInfo = MembersList(name: result.firstName ?? result.nickname, secondName: result.lastName ?? "", avatar: resultFromAvatar)
							self.membersListData.append(memberInfo)
						}
						
						
						dispatchSemaphore.signal()
					})
					
					dispatchSemaphore.wait()
				})
			}
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		} catch let err {
			print("error rorr \(err)")
		}
	}
	
	func gettingMembersAvatar(uid: Int, completion: @escaping (UIImage?) -> Void) {
		let groupRequestsFacade = GroupFacadeRequests()
		groupRequestsFacade.getRequest(typeParams: .getAvatar(groupId: uid))
		
		WebSocketNetworking.shared.socket.onData = { data in
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				print("gettingGroupAvatar res)")
				
				if let result = jsonResponse?["result"] as? [String: Any] {
					if let content = result["content"] as? String {
						guard let image = content.ConvertBase64StringToImage() else {print("error decodeData"); return }
						completion(image)
					}
				} else {
					completion(nil)
				}
				
				
			} catch let error {
				print("gettingGroupAvatar \(error)")
				completion(nil)
			}
			
		}
	}
	
	deinit {
		print("membersController deinited")
	}
	
	func delegating () {
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
	}
	
	@objc func addTapped () {
		if let segue = storyboard?.instantiateViewController(withIdentifier: "addUserStoryId") as? AddNewUserViewController {
			segue.storageCurrentIdGroup = storageIdGroup
			segue.updateMemberListDelegate = self
			navigationController?.pushViewController(segue, animated: true)
		}
	}
}

extension MembersControllerView: UITableViewDelegate, UITableViewDataSource, MemberListUpdateble {
	
	func updateMemberListWithNewUsers() {
		print("protocol succesed")
		membersListData.removeAll()
		gettingMembersInGroup()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return modelMemberList.count
		return membersListData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "memberViewCellId", for: indexPath) as? MembersCell {
			
//			cell.nameLabel.text = modelMemberList[indexPath.row].nickname
//           cell.secondNameLabel.isHidden = true
			cell.nameLabel.text = membersListData[indexPath.row].name
			cell.secondNameLabel.text = membersListData[indexPath.row].secondName
			cell.avatar.image = membersListData[indexPath.row].avatar
			return cell
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55
	}
}
