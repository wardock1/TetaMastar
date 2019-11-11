//
//  EventRequestStartedCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 09/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol GroupCreationRequestRespondent: class {
	func declineGroupCreation(for indexPath: IndexPath, requestData: GroupCreateStartedRequestCell)
	func confirmGroupCreationg(for indexPath: IndexPath, requestData: GroupCreateStartedRequestCell)
	func markGroupCreationRequest(for indexPath: IndexPath, requestData: GroupCreateStartedRequestCell)
}

class GroupCreateStartedRequestCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var secondNameLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var declineButton: UIButton!
	@IBOutlet weak var mainGroupLabel: UILabel!
	
	weak var groupCreatingRespondentDelegate: GroupCreationRequestRespondent?
	
	var currentIndexPath: IndexPath!
	var currentGroupCreationRequest: GroupCreateStartedRequestCell!
	
	var item: TypeCellViewModelItem? {
		didSet {
			guard let item = item as? GroupCreatedStartedRequest else {
				return
			}
			if let currentIndex = currentIndexPath?.row {
				let currentItem = item.groupCreatedRequestStartedNW[currentIndex]
				nameLabel.text = currentItem.data?.request?.title ?? "HWI"
				secondNameLabel.text = currentItem.data?.request?.initiator?.nickname ?? "WEQ"
				typeLabel.text = currentItem.type
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func currentGroupCreationRequestAndIndexPath(at indexPath: IndexPath, currentRequest: GroupCreateStartedRequestCell) {
		currentIndexPath = indexPath
		currentGroupCreationRequest = currentRequest
	}
	
	@IBAction func acceptButtonTapped(_ sender: UIButton) {
		groupCreatingRespondentDelegate?.confirmGroupCreationg(for: currentIndexPath, requestData: currentGroupCreationRequest)
	}
	
	@IBAction func declineButtonTapped(_ sender: UIButton) {
		groupCreatingRespondentDelegate?.declineGroupCreation(for: currentIndexPath, requestData: currentGroupCreationRequest)
	}
	
	func setDecorationButtons() {
		acceptButton.layer.cornerRadius = 12
		acceptButton.layer.masksToBounds = true
		acceptButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		declineButton.layer.cornerRadius = 12
		declineButton.layer.masksToBounds = true
		declineButton.backgroundColor = .clear
		declineButton.setTitleColor(#colorLiteral(red: 0.257500715, green: 0.7256385985, blue: 0.9175810239, alpha: 1), for: .normal)
		let bor = [Colors.colorOne, Colors.borderTwo, Colors.borderThree]
		declineButton.layer.setGradienBorder(colors: bor, width: 2)
		
	}
}
