//
//  UserAddedToGroupCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 12/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol UserAddedToGroupMarkble: class {
	func markNotificationUserAddedToGroup (at: IndexPath, requestData: UserAddedToGroupCell)
}

class UserAddedToGroupCell: UITableViewCell {

	@IBOutlet weak var addedUserLabel: UILabel!
	@IBOutlet weak var groupLabel: UILabel!
	@IBOutlet weak var okayButton: UIButton!
	
	weak var markNotificationUserAddedToGroupDelegate: UserAddedToGroupMarkble?
	
	var currentIndex: Int!
	var currentIndexPath: IndexPath?
	var currentNotificationUserAddedToGroup: UserAddedToGroupCell!
	var currentIndexPathRow: Int!
	
	var item: TypeCellViewModelItem? {
		didSet {
			guard let item = item as? UserAddedToGroup else {
				return
			}
			
			if let currentIndex = currentIndexPath?.row {
				let currentItem = item.userAddedToGroup[currentIndex]
				addedUserLabel.text = currentItem.data?.addedBy?.nickname
				groupLabel.text = currentItem.data?.group?.title
			}
			
			
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        setDecorationButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func currentUserAddedNotifAndIndexPath(at indexPath: IndexPath, currentUserAddedNotif: UserAddedToGroupCell) {
		currentIndexPath = indexPath
		currentNotificationUserAddedToGroup = currentUserAddedNotif
	}

	@IBAction func okayButtonTapped(_ sender: UIButton) {
		guard let currentIndexPath = currentIndexPath else { return }
		markNotificationUserAddedToGroupDelegate?.markNotificationUserAddedToGroup(at: currentIndexPath, requestData: currentNotificationUserAddedToGroup)
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
