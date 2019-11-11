//
//  SubGroupTableViewCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 16/10/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class SubGroupTableViewCell: UITableViewCell {

	@IBOutlet weak var groupAvatar: UIImageView!
	@IBOutlet weak var groupName: UILabel!
	@IBOutlet weak var groupDescriotion: UILabel!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
