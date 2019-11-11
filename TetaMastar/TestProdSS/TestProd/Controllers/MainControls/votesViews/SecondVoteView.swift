//
//  secondVoteView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class SecondVoteView: UIViewController {
	
	@IBOutlet weak var pollUserNameLabel: UILabel!
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var firstButton: UIButton!
	@IBOutlet weak var secondButton: UIButton!
	@IBOutlet weak var thirdButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	
	var questions: [Question]!
	var currentQuestion = 0
	var professionalism = 0
	var storageEventId: String? {
		didSet {
			print("secondVoteView eventID: \(String(describing: storageEventId))")
		}
	}
	var subjectUserId: String?
	
	var storageDisciplineGradeValue: Int?
	var disciplineGradeValue: Int? {
		didSet {
			print("discip self: \(String(describing: self.disciplineGradeValue))")
		}
	}
	
	var storagePollUserId: Int?
	var currentPollUserId: Int?
	var storagePollUserName: String?
	var currentPollUserName: String? {
		didSet {
			pollUserNameLabel.text = currentPollUserName
		}
	}
	
	var currentResultRating = [RatingInMyGroupModel.result]() {
		didSet {
			print("currentResult here 2 \(self.currentResultRating.count)")
		}
	}
	var storageCurrentResultRating = [RatingInMyGroupModel.result]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadQuestion()
		showQuestion(0)
		disciplineGradeValue = storageDisciplineGradeValue
		currentResultRating = storageCurrentResultRating
		currentPollUserId = storagePollUserId
		currentPollUserName = storagePollUserName
		setDecorationButtons()
	}
	
	@IBAction func firstButtonTapped(_ sender: UIButton) {
		selectAnswer(0)
	}
	@IBAction func secondButtonTapped(_ sender: UIButton) {
		selectAnswer(1)
	}
	@IBAction func thirdButtonTapped(_ sender: UIButton) {
		selectAnswer(2)
	}
	@IBAction func saveButtonTapped(_ sender: UIButton) {
		if let thirdVoteView = storyboard?.instantiateViewController(withIdentifier: "thirdVoteView") as? ThirdVoteView {
			thirdVoteView.storageEventId = storageEventId
			thirdVoteView.subjectUserId = subjectUserId
			thirdVoteView.storageDisciplineGradeValue = storageDisciplineGradeValue
			thirdVoteView.storageProfessionalism = professionalism
			thirdVoteView.storageCurrentResultRating = currentResultRating
			thirdVoteView.storagePollUserId = currentPollUserId
			thirdVoteView.storagePollUserName = currentPollUserName
			present(thirdVoteView, animated: true, completion: nil)
		}
	}
	
	func loadQuestion() -> Void {
		let question1 = Question(
			question: "Выполняет поручения руководителя ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Частично", returnValue: 0),
				Answer(answer: "Нет", returnValue: -1)
			]
		)
		
		let question2 = Question(
			question: "Имеет достаточно знаний для выполнения задач ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question3 = Question(
			question: "Заинтересован в получении новых знаний ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question4 = Question(
			question: "На данный момент повышает квалификацию?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question5 = Question(
			question: "Проявляет высокую заинтересованность к работе ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		self.questions = [question1, question2, question3, question4, question5]
	}
	
	func showQuestion(_ questionId : Int) -> Void {
		enableButtons()
		
		let selectedQuestion : Question = questions[questionId]
		questionLabel.text = selectedQuestion.question
		
		firstButton.setTitle(selectedQuestion.answers[0].response, for: .normal)
		secondButton.setTitle(selectedQuestion.answers[1].response, for: .normal)
		if selectedQuestion.answers[2].response == "" {
			thirdButton.isHidden = true
		} else {
			thirdButton.setTitle(selectedQuestion.answers[2].response, for: .normal)
		}
		
	}
	
	func disableButtons() -> Void {
		firstButton.isEnabled = false
		secondButton.isEnabled = false
		thirdButton.isEnabled = false
		questionLabel.isHidden = true
	}
	
	func enableButtons() -> Void {
		firstButton.isEnabled = true
		secondButton.isEnabled = true
		thirdButton.isEnabled = true
		questionLabel.isHidden = false
	}
	
	func selectAnswer(_ answerId : Int) -> Void {
		disableButtons()
		
		let answer : Answer = questions[currentQuestion].answers[answerId]
		print("answer is: \(String(describing: answer.response))")
		print("answerValue is: \(answer.returnValue)")
		professionalism += answer.returnValue
		
		nextQuestion()
	}
	
	func nextQuestion() {
		currentQuestion += 1
		
		if (currentQuestion < questions.count) {
			showQuestion(currentQuestion)
			saveButton.isEnabled = false
		} else {
			endQuiz()
		}
	}
	
	func endQuiz() {
		saveButton.setTitle("Перетий к следующей части", for: .normal)
		saveButton.isEnabled = true
		print("game is ended, proffesionalism: \(professionalism)")
	}
	
	func setDecorationButtons() {
		firstButton.layer.cornerRadius = 17
		firstButton.layer.masksToBounds = true
		firstButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		secondButton.layer.cornerRadius = 17
		secondButton.layer.masksToBounds = true
		secondButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		thirdButton.layer.cornerRadius = 17
		thirdButton.layer.masksToBounds = true
		thirdButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		saveButton.layer.cornerRadius = 17
		saveButton.layer.masksToBounds = true
		saveButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
	
	
}
