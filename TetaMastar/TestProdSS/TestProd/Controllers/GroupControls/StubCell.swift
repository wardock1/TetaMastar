//
//  StubCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 11/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class StubCell: UITableViewCell {

	@IBOutlet weak var noEventLabel: UILabel!
	@IBOutlet weak var noEventImage: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
