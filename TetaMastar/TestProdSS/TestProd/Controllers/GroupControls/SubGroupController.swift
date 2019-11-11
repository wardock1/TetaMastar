//
//  SubGroupController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 16/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class SubGroupController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var currentGroupListResult = [NewGroupListWithAvatar1.result]()
	var storageCurrentGroupListResult = [NewGroupListWithAvatar1.result]()
	
	var wwd = [1, 2, 3]
	
	var ttest = [SingleGroupInfo.result]() {
		didSet {
			print("ttest is: \(self.ttest.count)")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegating()
		currentGroupListResult = storageCurrentGroupListResult
		setCurrentGroupData()
	}
	
	func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
	}
	
	func setCurrentGroupData() {
		currentGroupListResult.forEach { (result) in
			result.children.forEach({ (result2) in
				gettingCurrentGroupInfo(groupId: result2)
				print("result is \(result2)")
			})
		}
	}
	
	func gettingCurrentGroupInfo(groupId: Int) {
		let groupFacade = GroupFacadeRequests()
		groupFacade.getRequest(typeParams: .getInfo(groupId: groupId))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			print("gettingCurrentGroupInfo here")
			
			do {
				let jsonResponse = try JSONDecoder().decode(SingleGroupInfo.self, from: data)
				print("jsonRessong gettinCGInfo: \(jsonResponse)")
				self.ttest.append(jsonResponse.result)
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
				
			} catch let error {
				print("error gettinCGInfo: \(error)")
			}
			
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "fromSubGroupsToDetailSubGroup" {
			guard let destinationVC = segue.destination as? SubGroupDetailViewController else { return }
			
			if let currentIndex = tableView.indexPathForSelectedRow {
				let currentIndex1 = ttest[currentIndex.row]
				destinationVC.storageCurrentSubGroup.append(currentIndex1)
				
			}
			
		}
	}
}

extension SubGroupController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if ttest.isEmpty {
			return 1
		} else {
			return ttest.count
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if ttest.isEmpty {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "stubSubCell", for: indexPath) as? StubSubGroupCell {
				
				return cell
			}
		} else {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "subgroupcell", for: indexPath) as? SubGroupTableViewCell {
				cell.groupName.text = ttest[indexPath.row].title
				cell.groupDescriotion.text = ttest[indexPath.row].description
				
				return cell
			}
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if ttest.isEmpty {
			return 180
		} else {
			return 70
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
