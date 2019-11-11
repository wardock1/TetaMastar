//
//  MembersCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 22/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class MembersCell: UITableViewCell {
	
	
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var secondNameLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setDecorationButtons()
	}
	
	func setDecorationButtons() {
		
	}
	
}
