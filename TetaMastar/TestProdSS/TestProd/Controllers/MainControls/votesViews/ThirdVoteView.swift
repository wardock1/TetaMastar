//
//  ThirdVoteView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class ThirdVoteView: UIViewController {
	
	@IBOutlet weak var firstSlider: UISlider!
	@IBOutlet weak var secondSlider: UISlider!
	@IBOutlet weak var thirdSlider: UISlider!
	@IBOutlet weak var fourthSlider: UISlider!
	@IBOutlet weak var saveButton: UIButton!
	
	
	@IBOutlet weak var labelFirtSlider: UILabel!
	@IBOutlet weak var labelSecondSlider: UILabel!
	@IBOutlet weak var labelThirdSlider: UILabel!
	@IBOutlet weak var labelFourthSlider: UILabel!
	
	var efficiency = 0
	var storageEventId: String? {
		didSet {
			print("thirdVoteView eventID: \(String(describing: storageEventId))")
		}
	}
	var subjectUserId: String?
	
	var storageDisciplineGradeValue: Int?
	var storageProfessionalism: Int?
	
	var disciplineGradeValue: Int?
	var professionalism: Int?
	
	var storagePollUserId: Int?
	var currentPollUserId: Int?
	var storagePollUserName: String?
	var currentPollUserName: String?
	
	var currentResultRating = [RatingInMyGroupModel.result]() {
		didSet {
			print("currentResult here 3 \(self.currentResultRating.count)")
		}
	}
	var storageCurrentResultRating = [RatingInMyGroupModel.result]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		disciplineGradeValue = storageDisciplineGradeValue
		professionalism = storageProfessionalism
		currentResultRating = storageCurrentResultRating
		currentPollUserId = storagePollUserId
		currentPollUserName = storagePollUserName
		setDecorationButtons()
	}
	
	var firstValueSlider = 0
	var secondValueSlider = 0
	var thirdValueSlider = 0
	var fourthValueSlider = 0
	
	@IBAction func firstSliderTapped(_ sender: UISlider) {		
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelFirtSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		firstValueSlider = Int(value)
	}
	@IBAction func secondSliderTapped(_ sender: UISlider) {
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelSecondSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		secondValueSlider = Int(value)
	}
	@IBAction func thirdSliderTapped(_ sender: UISlider) {
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelThirdSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		thirdValueSlider = Int(value)
	}
	@IBAction func fourthSliderTapped(_ sender: UISlider) {
		sender.setValue(sender.value.rounded(.down), animated: true)
		labelFourthSlider.text = "Текущее значение: \(Int(sender.value))"
		let value = sender.value
		fourthValueSlider = Int(value)
	}
	
	@IBAction func saveButtonTapped(_ sender: UIButton) {
		calculateDecision(firstSlide: firstValueSlider, secondSlider: secondValueSlider, thirdSlider: thirdValueSlider, fourthSlider: fourthValueSlider)
		if let fourthVoteView = storyboard?.instantiateViewController(withIdentifier: "FourthVoteView") as? FourthVoteView {
			fourthVoteView.storageEventId = storageEventId
			fourthVoteView.subjectUserId = subjectUserId
			fourthVoteView.storageProfessionalism = professionalism
			fourthVoteView.storageDisciplineGradeValue = disciplineGradeValue
			fourthVoteView.storageEffenciency = efficiency
			fourthVoteView.storageCurrentResultRating = currentResultRating
			fourthVoteView.storagePollUserName = currentPollUserName
			fourthVoteView.storagePollUserId = currentPollUserId
			print("game is ended, gradeValue: \(efficiency)")
			present(fourthVoteView, animated: true, completion: nil)
		}
	}
	
	func calculateDecision(firstSlide: Int, secondSlider: Int, thirdSlider: Int, fourthSlider: Int) {
		let decidion = firstSlide + secondSlider + thirdSlider + fourthSlider
		efficiency = decidion
	}
	
	func setDecorationButtons() {
		saveButton.layer.cornerRadius = 17
		saveButton.layer.masksToBounds = true
		saveButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
	
}
