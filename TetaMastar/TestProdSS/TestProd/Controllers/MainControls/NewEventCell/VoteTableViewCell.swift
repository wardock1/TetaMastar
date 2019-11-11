//
//  VoteTableViewCell.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 06/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

protocol Responsable: class {
	func responsable (for index: Int, with response: Int, and question: Question)
}

class VoteTableViewCell: UITableViewCell {
	
	
	@IBOutlet weak var imageViewCheckMark: UIImageView!
	@IBOutlet weak var secondImageViewCheckMark: UIImageView!
	@IBOutlet weak var thirdImageViewCheckMark: UIImageView!
	
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var firstButton: UIButton!
	@IBOutlet weak var secondButton: UIButton!
	@IBOutlet weak var thirdButton: UIButton!
	let checkMark = UIImage(named: "checkMark")
	
	
	var buttonsArray = [UIButton]()
	
	weak var responsableDelegate: Responsable?
	
	var currentIndex: Int!
	var currentQuestion1: Question!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		buttonsArray.append(firstButton)
		buttonsArray.append(secondButton)
		buttonsArray.append(thirdButton)
		
		
    }
	
	
	func currentIndexAndResponse(index: Int, currentQuestion: Question) {
		currentIndex = index
		print("currentQuestion: \(currentQuestion)")
		currentQuestion1 = currentQuestion
		
	}
	
	
	@IBAction func firstButtonTapped(_ sender: UIButton) {
		print("first button")
		responsableDelegate?.responsable(for: currentIndex, with: 0, and: currentQuestion1)
		
		for button in buttonsArray {
			button.isSelected = false
		}
		if let index = buttonsArray.firstIndex(where: { $0 == sender }) {
			print("index: \(index)")
			buttonsArray[index].isSelected = true
		}
		
	}
	
	@IBAction func secondButtonTapped(_ sender: UIButton) {
		print("second button")
		responsableDelegate?.responsable(for: currentIndex, with: 1, and: currentQuestion1)
		
		for button in buttonsArray {
			button.isSelected = false
		}
		if let index = buttonsArray.firstIndex(where: { $0 == sender }) {
			print("index: \(index)")
			buttonsArray[index].isSelected = true
		}
	}
	
	@IBAction func thirButtonTapped(_ sender: UIButton) {
		print("third button")
		responsableDelegate?.responsable(for: currentIndex, with: 2, and: currentQuestion1)
		
		for button in buttonsArray {
			button.isSelected = false
		}
		if let index = buttonsArray.firstIndex(where: { $0 == sender }) {
			buttonsArray[index].isSelected = true
		}
	}
	
}
