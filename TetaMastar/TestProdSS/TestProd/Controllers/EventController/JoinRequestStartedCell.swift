//
//  EventControllerCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 01/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol InvitationDeclinedbly: class {
	func declineJoinRequestToGroup (for indexPath: IndexPath, invitationData: JoinRequestStartedCell)
	func confirmJoinRequestToGroup (for indexPath: IndexPath, invitationData: JoinRequestStartedCell)
}

class JoinRequestStartedCell: UITableViewCell {
	
	@IBOutlet weak var nameUserFromInvitation: UILabel!
	@IBOutlet weak var nameUserToInvition: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var deniedButton: UIButton!
	
	weak var joinToGroupStartedDelegate: InvitationDeclinedbly?
	
	var currentIndexPath: IndexPath?
	var currentJoinRequestStartedCell: JoinRequestStartedCell!
	
	var item: TypeCellViewModelItem? {
		didSet {
			guard let item = item as? JoinToGroupReqeustStarted else {
				return
			}
			if let currentIndex = currentIndexPath?.row {
				let currentItem = item.joinRequestStarted[currentIndex]
				nameUserFromInvitation.text = currentItem.data.request?.status ?? "WEQ"
				nameUserToInvition.text = currentItem.data.request?.group?.title ?? "WEQ"
			}
		}
	}
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setDecorationButtons()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
		bounds = bounds.inset(by: padding)
	}
	
	func currentJoinRequestAndIndexPath(at indexPath: IndexPath, currentRequest: JoinRequestStartedCell) {
		currentIndexPath = indexPath
		currentJoinRequestStartedCell = currentRequest
	}
	
	@IBAction func confirmTapped(_ sender: UIButton) {
		guard let currentIndexPath = currentIndexPath else { return }
		joinToGroupStartedDelegate?.confirmJoinRequestToGroup(for: currentIndexPath, invitationData: currentJoinRequestStartedCell)
	}
	
	@IBAction func deniedTapped(_ sender: UIButton) {
		guard let currentIndexPath = currentIndexPath else { return }
		joinToGroupStartedDelegate?.declineJoinRequestToGroup(for: currentIndexPath, invitationData: currentJoinRequestStartedCell)
	}
	
	func setDecorationButtons() {
		confirmButton.layer.cornerRadius = 17
		confirmButton.layer.masksToBounds = true
		confirmButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		deniedButton.layer.cornerRadius = 17
		deniedButton.layer.masksToBounds = true
		deniedButton.backgroundColor = .clear
		deniedButton.setTitleColor(#colorLiteral(red: 0.257500715, green: 0.7256385985, blue: 0.9175810239, alpha: 1), for: .normal)
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		deniedButton.layer.setGradienBorder(colors: bor, width: 5)
		
	}
}
