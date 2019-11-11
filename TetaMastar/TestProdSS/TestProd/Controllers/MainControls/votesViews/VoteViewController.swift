//
//  VoteViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 18/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {
	
	@IBOutlet weak var currentUserLabel: UILabel!
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var firstButton: UIButton!
	@IBOutlet weak var secondButton: UIButton!
	@IBOutlet weak var thirdButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	var userInfo: User!
	var questions: [Question]!
	var currentQuestion = 0
	var disciplineGradeValue = 0
	var subjectUserId: String?
	var eventId: String? {
		didSet {
			print("voteView eventID: \(String(describing: eventId))")
		}
	}
	
	var storagePollUserId: Int?
	var currentPollUserId: Int?
	var storagePollUserName: String?
	var currentPollUserName: String? {
		didSet {
			currentUserLabel.text = currentPollUserName
		}
	}
	
	var currentResultRating = [RatingInMyGroupModel.result]() {
		didSet {
			print("currentResult here 1 \(self.currentResultRating.count)")
		}
	}
	var storageCurrentResultRating = [RatingInMyGroupModel.result]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		saveButton.isEnabled = false
		loadQuestion()
		showQuestion(0)
		loadUserInfo()
		currentResultRating = storageCurrentResultRating
		currentPollUserId = storagePollUserId
		currentPollUserName = storagePollUserName
		setDecorationButtons()
	}
	
	func loadUserInfo() {
		
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
		let secondVoteView = storyboard?.instantiateViewController(withIdentifier: "secondVoteView") as? SecondVoteView
		secondVoteView?.storageEventId = eventId
		secondVoteView?.subjectUserId = subjectUserId
		secondVoteView?.storageDisciplineGradeValue = disciplineGradeValue
		secondVoteView?.storageCurrentResultRating = currentResultRating
		secondVoteView?.storagePollUserId = currentPollUserId
		secondVoteView?.storagePollUserName = currentPollUserName
		present(secondVoteView!, animated: true, completion: nil)
		
		
	}
	
	func loadQuestion() -> Void {
		let question1 = Question(
			question: "Были ли случаи опоздания на работу ?",
			answers: [
				Answer(answer: "Да", returnValue: 0),
				Answer(answer: "Нет", returnValue: 1),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question2 = Question(
			question: "Как часто? (если были)",
			answers: [
				Answer(answer: "Несколько раз в месяц", returnValue: 0),
				Answer(answer: "Несколько раз в неделю", returnValue: -1),
				Answer(answer: "Приходит во время", returnValue: 0)
			]
		)
		
		let question3 = Question(
			question: "Общается на отвлеченные темы ?",
			answers: [
				Answer(answer: "Редко", returnValue: 0),
				Answer(answer: "Часто", returnValue: -1),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question4 = Question(
			question: "Был замечен в нетрезвом состоянии ?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 1),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question5 = Question(
			question: "Уходит с работы по личным причинам ?",
			answers: [
				Answer(answer: "Да, предупреждает", returnValue: 0),
				Answer(answer: "Да, не предупреждает", returnValue: -1),
				Answer(answer: "Нет", returnValue: 1)
			]
		)
		
		let question6 = Question(
			question: "Как часто? (если уходит)",
			answers: [
				Answer(answer: "Несколько раз в неделю", returnValue: 0),
				Answer(answer: "Несколько раз в месяц.", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question7 = Question(
			question: "Соблюдает вежливость в общении с коллегами?",
			answers: [
				Answer(answer: "Да, со всеми", returnValue: 1),
				Answer(answer: "Нет, не со всеми", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question8 = Question(
			question: "Допускает провокационные ситуации?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 1),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		self.questions = [question1, question2, question3, question4, question5, question6, question7, question8]
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
		disciplineGradeValue += answer.returnValue
		print("vvvvvv:\(disciplineGradeValue)")
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
		print("game is ended, gradeValue: \(disciplineGradeValue)")
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
