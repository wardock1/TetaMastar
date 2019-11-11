//
//  GroupCreatedRequestDeniedCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 11/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol GroupCreationNotificationDeniedMarkble: class {
	func markGroupCreationDeniedNotification (for indexPath: IndexPath, requestData: GroupCreatedRequestDeniedCell)
}

class GroupCreatedRequestDeniedCell: UITableViewCell {
	
	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var okayButton: UIButton!
	
	weak var markDeniedNotificationDelegate: GroupCreationNotificationDeniedMarkble?
	
	var currentIndexPath: IndexPath?
	var currentDeniedGroupCreationRequest: GroupCreatedRequestDeniedCell!
//	var currentIndexPathRow: Int?
	
	var item: TypeCellViewModelItem? {
		didSet {
			guard let item = item as? GroupCreatedRequestDenied else { return }
			var itemType = ""
			
			if let currentIndex = currentIndexPath?.row {
				let currentItem = item.groupCreatedRequestDenied[currentIndex]
				if let type = currentItem.type {
					itemType = type
				}
			}
			
			switch itemType {
			case "notification.groupcreationrequestdenied":
				item.groupCreatedRequestDenied.forEach { (result) in
					guard let title = result.data?.request?.title else { return }
					groupNameLabel.text = title
				}
				statusLabel.text = "Отказано"
				
			case "notification.groupcreationrequestaccepted":
				item.groupCreatedRequestDenied.forEach { (result) in
					guard let title = result.data?.request?.title else { return }
					groupNameLabel.text = title
				}
				statusLabel.text = "Согласовано"
			default:
				break
				//			}
				
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setDecorationButton()
	}
	
	func currentDeniedRequestAndIndexPath(at indexPath: IndexPath, currentRequest: GroupCreatedRequestDeniedCell) {
		currentIndexPath = indexPath
		currentDeniedGroupCreationRequest = currentRequest
	}
	
	@IBAction func okayButtonTapped(_ sender: UIButton) {
		guard let currentIndexPath = currentIndexPath else { return }
		markDeniedNotificationDelegate?.markGroupCreationDeniedNotification(for: currentIndexPath, requestData: currentDeniedGroupCreationRequest)
		print("okeyButtonTapped")
	}
	
	func setDecorationButton() {
		okayButton.layer.cornerRadius = 15
		okayButton.layer.masksToBounds = true
		okayButton.backgroundColor = .clear
		okayButton.setTitleColor(#colorLiteral(red: 0.257500715, green: 0.7256385985, blue: 0.9175810239, alpha: 1), for: .normal)
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		okayButton.layer.setGradienBorder(colors: bor, width: 5)
	}
}
