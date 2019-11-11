//
//  NewTableViewCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 09/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol NotificationMarkable: class {
	func markNotificationGroupCreated (for indexPath: IndexPath, requestData: GroupCreatedCell)
}

class GroupCreatedCell: UITableViewCell {
	
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var secondNameLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	
	weak var declineDelegate: NotificationMarkable?
	
	var currentIndexPath: IndexPath?
	var currentGroupCreatedCell: GroupCreatedCell!
	
	var item: TypeCellViewModelItem? {
		didSet {
			guard let item = item as? GroupCreated else {
				return
			}
			
			if let currentIndex = currentIndexPath?.row {
				let currentItem = item.groupCreated[currentIndex]
				nameLabel.text = currentItem.data.creator?.nickname ?? "WSAD"
				secondNameLabel.text = currentItem.data.group?.title ?? "HWI"
				typeLabel.text = currentItem.type
			}
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	func currentGroupCreatedNotificationAndIndexPath(at indexPath: IndexPath, dataInvitation: GroupCreatedCell) {
		currentIndexPath = indexPath
		currentGroupCreatedCell = dataInvitation
	}
	
	@IBAction func markedButtonTapped(_ sender: UIButton) {
		guard let currentIndexPath = currentIndexPath else { return }
		declineDelegate?.markNotificationGroupCreated(for: currentIndexPath, requestData: currentGroupCreatedCell)
	}

}
