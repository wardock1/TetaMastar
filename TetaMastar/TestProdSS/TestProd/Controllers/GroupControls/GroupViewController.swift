//
//  GroupViewController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Locksmith

//protocol GroupListUpdatable: class {
//	func updateGroupList()
//}

struct GroupListNn {
	let title: String
	let description: String
	let checksum: String
	let avatar: UIImage?
}

struct OrgList {
	let title: String
	let id: Int
	let checksum: String
	var avatar: UIImage?
}

struct OrgListAvatars {
	let checksum: String
	let content: String
}

class GroupViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableVIew: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	let facadeGroup = GroupFacadeRequests()
	
	let tableViewForSetting = UITableView()
	var selectedButton = UIButton()
	let transparentView = UIView()
//	let dataFortableViewForSetting = ["Создать новый проект", "Создать новую группу", "Открыть запрос на вступление в группу"]
	var dataFortableViewForSetting = [String]()
	
	var groupListArray = [GroupList]()
	var groupListResult = [NewGroupList.result]()
	
	var orgList = [OrgList]() {
		didSet {
			self.collectionView.reloadData()
			print("ORG LIST CHANGED: \(self.orgList.count)")
		}
	}
	var groupListNn = [GroupListNn]() {
		didSet {
			DispatchQueue.main.async {
				self.tableVIew.reloadData()
			}
		}
	}
	
	var groupListWithAvatar = [NewGroupListWithAvatar1.result]() {
		didSet {
			DispatchQueue.main.async {
				self.tableVIew.reloadData()
			}
		}
	}
	
	var searchingGroupList = [String]()
	var isSearching = false
	
	//	lazy var refresher: UIRefreshControl = {
	//		let refreshControl = UIRefreshControl()
	//		refreshControl.tintColor = .white
	//		refreshControl.addTarget(self, action: #selector(refreshDataInGroupList), for: .valueChanged)
	//		return refreshControl
	//	}()
	//
	//	@objc func refreshDataInGroupList() {
	//		print("REFRESH")
	//		DispatchQueue.main.async {
	//			self.gettingGroup()
	//			self.groupListNn.removeAll()
	//			self.orgList.removeAll()
	////			self.tableVIew.reloadData()
	//		}
	//		refresher.endRefreshing()
	//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//		settingsButton.setImage(settingImage, for: .normal)
		settingsButton.isHidden = true
		settingsButton.isEnabled = false
		tableVIew.separatorStyle = .none
		tableVIew.delegate = self
		tableVIew.dataSource = self
		tableViewForSetting.delegate = self
		tableViewForSetting.dataSource = self
		collectionView.delegate = self
		collectionView.dataSource = self
		searchBar.delegate = self
		tableVIew.allowsMultipleSelection = false
//		gettingGroup()
		//		tableVIew.refreshControl = refresher
		self.hideKeyboardWhenTappedAround()
		self.tableViewForSetting.register(GroupSettingCell.self, forCellReuseIdentifier: "settingCell")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonItemAddTarget))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		orgList.removeAll()
		groupListWithAvatar.removeAll()
		gettingGroup()
	}
	
	@objc func rightBarButtonItemAddTarget() {
		selectedButton = settingsButton
		dataFortableViewForSetting = ["Создать новый проект", "Создать новую группу", "Открыть запрос на вступление в группу"]
		addTransparentView(frames: settingsButton.frame)
	}
	
	deinit {
		print("GroupVC deinited")
	}
	
	func addTransparentView(frames: CGRect) {
		transparentView.isHidden = false
		tableViewForSetting.isHidden = false
		let window = UIApplication.shared.keyWindow
		transparentView.frame = window?.frame ?? self.view.frame
		self.view.addSubview(transparentView)
		
		tableViewForSetting.frame = CGRect(x: frames.origin.x - 5, y: frames.origin.y + frames.height - 30, width: -320, height: CGFloat(self.dataFortableViewForSetting.count * 50))
		self.view.addSubview(tableViewForSetting)
		tableViewForSetting.layer.cornerRadius = 5
		transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
		transparentView.addGestureRecognizer(tapGesture)
		transparentView.alpha = 0.5
//		UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
//			self.transparentView.alpha = 0.5
////			self.tableViewForSetting.frame = CGRect(x: frames.origin.x - 5, y: frames.origin.y + frames.height - 30, width: -320, height: CGFloat(self.dataFortableViewForSetting.count * 50))
//		}, completion: nil)
		tableViewForSetting.reloadData()
		
	}
	
	@objc func removeTransparentView() {
//		let frames = settingsButton.frame
		UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
			self.transparentView.alpha = 0
//			self.tableViewForSetting.frame = CGRect(x: frames.origin.x - 5, y: frames.origin.y + frames.height - 30, width: -320, height: 0)
			self.transparentView.isHidden = true
			self.tableViewForSetting.isHidden = true
			self.dataFortableViewForSetting.removeAll()
		}, completion: nil)
	}
	
	@IBAction func settingButtonTapped(_ sender: UIButton) {
		
	}
	func gettingGroup() {
		facadeGroup.getRequest(typeParams: .getByMember)
		WebSocketNetworking.shared.socket.onData = { (data: Data) in
			self.testingParse(data: data)
			print("GROUPVIEW SHIT")
		}
	}
	
	func testingParse(data: Data) {
		do {
			let jsonResponse = try JSONDecoder().decode(NewGroupList.self, from: data)
			//			print("jsonResponse parse: \(jsonResponse)")
			groupListResult = jsonResponse.result
			
			let dispatchQueue = DispatchQueue(label: "taskQueueGroup")
			let dispatchSemaphore = DispatchSemaphore(value: 0)
			
			dispatchQueue.async {
				jsonResponse.result.forEach { (result) in
					let guid = result.id
					self.gettingGroupAvatar(uid: guid, completion: {[weak self] (image) in
						guard let self = self else { return }
						
						let organ = NewGroupListWithAvatar1.result.organization.init(id: result.organization.id, date: result.organization.date, title: result.organization.title, description: result.organization.description, director: result.organization.director, nickname: result.organization.nickname)
						
						let avatarMetaInfo1 = NewGroupListWithAvatar1.result.avatarMetaInfo.init(id: result.avatarMetaInfo.id, checksum: result.avatarMetaInfo.checksum, size: result.avatarMetaInfo.size, avatar: image)
						
						let mainGroupListWithAvatar1 = NewGroupListWithAvatar1.result(id: result.id, creator: result.creator, admin: result.admin, title: result.title, description: result.description, organization: organ, children: result.children, createdAt: result.createdAt, avatarMetaInfo: avatarMetaInfo1)
						self.groupListWithAvatar.append(mainGroupListWithAvatar1)
						dispatchSemaphore.signal()
					})
					dispatchSemaphore.wait()
				}
				self.gettinInfoAboutOrgList()
			}
			
			//			gettinInfoAboutOrgList()
			
			//			DispatchQueue.main.async {
			//				self.tableVIew.reloadData()
			//			}
		} catch let err {
			print("error rorr \(err)")
			do {
				if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
					print(jsonResponse)
				}
			} catch {
				print("error didReceiveData")
			}
		}
	}
	
	func gettingGroupAvatar(uid: Int, completion: @escaping (UIImage) -> Void) {
		let groupRequestsFacade = GroupFacadeRequests()
		groupRequestsFacade.getRequest(typeParams: .getAvatar(groupId: uid))
		
		WebSocketNetworking.shared.socket.onData = { data in
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				print("gettingGroupAvatar res)")
				guard let result = jsonResponse?["result"] as? [String: Any] else {print("result error"); return }
				guard let content = result["content"] as? String else { print("error content"); return }
				//				guard let checksum = result["checksum"] as? String else { print("error checksum"); return }
				guard let image = content.ConvertBase64StringToImage() else {print("error decodeData"); return }
				
				completion(image)
				
			} catch let error {
				print("gettingGroupAvatar \(error)")
			}
			
		}
	}
	
	@IBAction func orgButtonTapped(_ sender: UIButton) {
		
	}
	
	func gettinInfoAboutOrgList() {
		let orgRequestsFacade = OrganizationRequestsFacade()
		orgRequestsFacade.getRequest(typeParams: .orgGetAllByAdmin)
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			
			do {
				let jsonResponse = try JSONDecoder().decode(GetByAdminOrgModel.self, from: data)
				guard let orgListResultFromJson = jsonResponse.result else { return }
				
				let dispatchQueue = DispatchQueue(label: "taskQueue")
				let dispatchSemaphore = DispatchSemaphore(value: 0)
				
				dispatchQueue.async {
					orgListResultFromJson.director?.forEach({ (result) in
						
						//						print("gettinInfoAboutOrgList 1")
						guard let title = result.title else { return }
						guard let orgId = result.id else { return }
						guard let checksum = result.avatarMetaInfo?.checksum else { return }
						//						print("title is: \(title)")
						
						self.ttest(orgId: orgId, completion: { (image) in
							let ww = OrgList(title: title, id: orgId, checksum: checksum, avatar: image)
							self.orgList.append(ww)
							//							print("sema signal")
							dispatchSemaphore.signal()
						})
						dispatchSemaphore.wait()
					})
					
					orgListResultFromJson.linked?.forEach({ (result) in
						guard let title = result.title else { return }
						guard let orgId = result.id else { return }
						guard let checksum = result.avatarMetaInfo?.checksum else { return }
						self.ttest(orgId: orgId, completion: { (image) in
							let ww = OrgList(title: title, id: orgId, checksum: checksum, avatar: image)
							self.orgList.append(ww)
							dispatchSemaphore.signal()
						})
						dispatchSemaphore.wait()
					})
					
				}
				
			} catch let error {
				print("gettingDataAboutOrg error111111: \(error)")
			}
		}
	}
	
	func ttest(orgId: Int, completion: @escaping (UIImage) -> Void) {
		let orgRequestsFacade = OrganizationRequestsFacade()
		orgRequestsFacade.getRequest(typeParams: .orgGetAvatar(orgId: orgId))
		
		WebSocketNetworking.shared.socket.onData = { data in
			print("gettingOrgAvatar answer")
			do {
				print("parase avatar 22222")
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				guard let result = jsonResponse?["result"] as? [String: Any] else {print("error content"); return }
				guard let content = result["content"] as? String else { print("error content"); return }
//				guard let checksum = result["checksum"] as? String else { print("error checksum"); return }
				
				guard let decodeData = Data(base64Encoded: content, options: .ignoreUnknownCharacters) else {print("error decodeData"); return }
				guard let image = UIImage(data: decodeData) else { return }
				completion(image)
				
			} catch let error {
				print("eror parseGetInfoAboutUser: \(error)")
			}
		}
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text == nil || searchBar.text == "" {
			isSearching = false
			view.endEditing(true)
			tableVIew.reloadData()
		} else {
			isSearching = true
			let groupName = groupListArray.map { (value) -> String in
				return value.name
			}
			searchingGroupList = groupName.filter({$0.prefix(searchText.count) == searchText})
			tableVIew.reloadData()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "fromGroupToDetailSegue" {
			let destinationVC = segue.destination as? DetailViewController
			
			if let currentIndex = tableVIew.indexPathForSelectedRow {
				
				//				let currentIndex = groupListResult[currentIndex.row]
				let currentIndex = groupListWithAvatar[currentIndex.row]
				destinationVC?.storageCurrentGroupListData.append(currentIndex)
				
				destinationVC?.storageNameLabel = currentIndex.title
				destinationVC?.storageDescrpLabel = currentIndex.description
				destinationVC?.storageAvatarGroup = currentIndex.avatarMetaInfo.avatar
				destinationVC?.storageAdminIdLabel = currentIndex.admin
//				removeTransparentView()
			}
			
		}
		
		if segue.identifier == "fromGroupToAddNewGroup" {
			if let destinationVC = segue.destination as? AddNewGroupController {
				destinationVC.storageGroupListResult = self.groupListResult
//				removeTransparentView()
			}
		}
		
		if segue.identifier == "fromGroupToOrgInfo" {
			if let destinationVC = segue.destination as? OrganizationViewController {
				guard let cell = sender as? UICollectionViewCell else { print("EROROR23123123"); return }
				guard let currentIndexPath = collectionView.indexPath(for: cell) else {print("EROROR23123123"); return }
				let currentData = orgList[currentIndexPath.row]
				
				destinationVC.storageOrgId = currentData.id
//				removeTransparentView()
//				print("currentIndexItemscurrentIndexItems : \(currentIndexPath.row)")
//				print("currentIndexItemscurrentIndexItemsIDIDID : \(currentData.id)")
//				print("currentIndexItemscurrentIndexItems : \(currentData)")
			}
		}
	}
	
}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
	
//	func updateGroupList() {
//		gettingGroup()
//	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		switch tableView {
		case tableVIew:
			//		return groupListResult.count
//			if isSearching {
//				return searchingGroupList.count
//			} else {
//				//	return groupListResult.count
//				return groupListWithAvatar.count
//			}
			
			if groupListWithAvatar.isEmpty {
				return 1
			} else {
				return groupListWithAvatar.count
			}
			
		case tableViewForSetting:
			return dataFortableViewForSetting.count
			
		default:
			return 3
		}
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch tableView {
		case tableVIew:
			
			if groupListWithAvatar.isEmpty {
				guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "stubCell", for: indexPath) as? StubCell else { return UITableViewCell()}
				
				return cell1
			} else if let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath) as? GroupListCell {
				if isSearching {
					cell.title.text = searchingGroupList[indexPath.row]
					
				} else {
					cell.title.text = groupListWithAvatar[indexPath.row].title
					cell.descriptionLabel.text = groupListWithAvatar[indexPath.row].description
					cell.avatar.image = groupListWithAvatar[indexPath.row].avatarMetaInfo.avatar
					
				}
				return cell
				
			}
			
		case tableViewForSetting: 
			let cell = tableViewForSetting.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
			cell.textLabel?.text = dataFortableViewForSetting[indexPath.row]
			cell.textLabel?.font = cell.textLabel?.font.withSize(14)
			return cell
			
		default:
			print("error tablevies")
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch tableView {
		case tableVIew:
			tableVIew.deselectRow(at: indexPath, animated: true)
			print("tableVIew d \(indexPath)")
		case tableViewForSetting:
			tableViewForSetting.deselectRow(at: indexPath, animated: true)
			let currentData = dataFortableViewForSetting[indexPath.row]
			print("tableViewForSetting d \(indexPath)")
			print("tableViewForSetting d \(dataFortableViewForSetting[indexPath.row])")
			if currentData == "Создать новый проект" {
				if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "createNewOrg") as? CreateOrganizationViewController {
					removeTransparentView()
					self.navigationController?.pushViewController(destinationVC, animated: true)
				}
			}
			if currentData == "Создать новую группу" {
				if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "addNewGroup") as? AddNewGroupController {
					removeTransparentView()
					self.navigationController?.pushViewController(destinationVC, animated: true)
				}
			}
			if currentData == "Открыть запрос на вступление в группу" {
				
			}
			
		default:
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch tableView {
		case tableVIew:
			
			if groupListWithAvatar.isEmpty {
				return 200
			} else {
				return 80
			}
		case tableViewForSetting:
			return 50
		default: return 80
		}
		
//		return 80
	}
	
}

extension GroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		if orgList.isEmpty {
			return 1
		} else {
			return orgList.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if orgList.isEmpty {
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stubOrgCell", for: indexPath) as? StubOrgCell {
				
				return cell
			}
		} else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orgCollectionViewCell", for: indexPath) as? OrganizationListCell {
			
			cell.orgTitle.text = orgList[indexPath.row].title
			cell.avatar.image = orgList[indexPath.row].avatar
			cell.avatar.layer.cornerRadius = 0.5 * cell.avatar.bounds.size.width
			return cell
		}
		return UICollectionViewCell()
	}
	
	//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	//		collectionView.deselectItem(at: indexPath, animated: true)
	//	}
	
}
