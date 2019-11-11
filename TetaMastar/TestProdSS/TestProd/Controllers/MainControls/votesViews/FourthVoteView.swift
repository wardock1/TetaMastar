//
//  FourthVoteView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 07/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit
import Locksmith

class FourthVoteView: UIViewController {
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var firstButton: UIButton!
	@IBOutlet weak var secondButton: UIButton!
	@IBOutlet weak var thirdButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var nextQuestionButton: UIButton!
	
	var questions: [Question]!
	
	var currentResultRating = [RatingInMyGroupModel.result]() {
		didSet {
			print("currentResult here 1 \(self.currentResultRating.count)")
		}
	}
	var storageCurrentResultRating = [RatingInMyGroupModel.result]()
	
	var currentQuestion = 0
	
	var loyalty = 0
	var storageEventId: String? {
		didSet {
			print("fourthVoteView: \(String(describing: storageEventId))")
		}
	}
	
	var storageDisciplineGradeValue: Int?
	var storageProfessionalism: Int?
	var storageEffenciency: Int?
	
	var disciplineGradeValue: Int?
	var professionalism: Int?
	var effenciency: Int?
	var userId: Int?
	var currentRatingId = 0
	
	var storagePollUserId: Int?
	var currentPollUserId: Int?
	var storagePollUserName: String?
	var currentPollUserName: String?
	
	var subjectUserId: String?
	
	var answerValueArray = [Int]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		saveButton.isHidden = true
		loadQuestion()
		showQuestion(0)
		
		disciplineGradeValue = storageDisciplineGradeValue
		professionalism = storageProfessionalism
		effenciency = storageEffenciency
		currentResultRating = storageCurrentResultRating
		currentPollUserId = storagePollUserId
		currentPollUserName = storagePollUserName
	}
	
	deinit {
		print("fourthVoteView deinited")
	}
	
	var first: Int?
	var second: Int?
	var third: Int?
	var fourth: Int?
	
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
		if let backToMainVC = storyboard?.instantiateViewController(withIdentifier: "groupViewController") as? GroupViewController {
			present(backToMainVC, animated: true, completion: nil)
		}
	}
	
	func loadQuestion() -> Void {
		let question1 = Question(
			question: "Проявляет инициативность ?",
			answers: [
				Answer(answer: "Да", returnValue: 3),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question2 = Question(
			question: "Поддерживает инициативу коллег ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question3 = Question(
			question: "Хорошо знает компанию ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question4 = Question(
			question: "Ставит интересы компании выше собственных ?",
			answers: [
				Answer(answer: "Да", returnValue: 1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question5 = Question(
			question: "Гордится своей работой ?",
			answers: [
				Answer(answer: "Да", returnValue: 2),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question6 = Question(
			question: "Критикует компанию на публике ?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question7 = Question(
			question: "Негативно реагирует на просьбы коллег ?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question8 = Question(
			question: "Проявляет агрессию в общении ?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question9 = Question(
			question: "Портит позитивную рабочую обстановку ?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		let question10 = Question(
			question: "Преследует личные/корыстные цели ?",
			answers: [
				Answer(answer: "Да", returnValue: -1),
				Answer(answer: "Нет", returnValue: 0),
				Answer(answer: "", returnValue: 0)
			]
		)
		
		self.questions = [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10]
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
		loyalty += answer.returnValue
		print("vvvvvv:\(String(describing: disciplineGradeValue))")
		nextQuestion()
	}
	
	func nextQuestion() {
		currentQuestion += 1
		
		if (currentQuestion < questions.count) {
			showQuestion(currentQuestion)
		} else {
			endQuiz()
		}
	}
	
//	func multiplayAnswers(first: Int?, second: Int?, third: Int?, fourth: Int?) {
//		if let first = first {
//			let answer : Answer = questions[currentQuestion].answers[first]
//			loyalty += answer.returnValue
//		}
//		if let second = second {
//			let answer : Answer = questions[currentQuestion].answers[second]
//			loyalty += answer.returnValue
//		}
//		if let third = third {
//			let answer : Answer = questions[currentQuestion].answers[third]
//			loyalty += answer.returnValue
//		}
//		if let fourth = fourth {
//			let answer : Answer = questions[currentQuestion].answers[fourth]
//			loyalty += answer.returnValue
//		}
//		print("currentValueLoalty: \(loyalty)")
//	}
	
//	func nextQuestion() {
//		currentQuestion += 1
//
//		if (currentQuestion < questions.count) {
//			showQuestion(currentQuestion)
//			firstButton.isSelected = false
//			secondButton.isSelected = false
//			thirdButton.isSelected = false
//			fourthButton.isSelected = false
//		} else {
//			endQuiz()
//		}
//	}
//
//	func disableButtons() {
//		firstButton.isHidden = true
//		secondButton.isHidden = true
//		thirdButton.isHidden = true
//		fourthButton.isHidden = true
//	}
	
	func endQuiz() {
		print("game is ended, gradeValue: \(loyalty)")
		saveButton.setTitle("Завершнить опрос", for: .normal)
		questionLabel.text = "Благодарим за Ваш отзыв"
		disableButtons()
		saveButton.isHidden = false
		
		currentResultRating.forEach { (result) in
			currentRatingId = result.id!
			estimateQuizToServer(curretinRQ: result.id!)
			print("result ID :\(String(describing: result.id))")
		}
		
	}
	
	func estimateQuizToServer(curretinRQ: Int) {
		
		print("poll User is, effe: \(String(describing: effenciency)), proff \(String(describing: professionalism)), disc \(String(describing: disciplineGradeValue)), loyalty: \(loyalty) currentRQ: \(curretinRQ)")
		guard let effeciency = effenciency else { return }
		guard let professionalism = professionalism else { return }
		guard let discipline = disciplineGradeValue else { return }
		guard let pollUser = currentPollUserId else { return }
		print("poll User is \(pollUser), effe: \(effeciency), proff \(professionalism), disc \(discipline), loyalty: \(loyalty) currentRQ: \(curretinRQ)")
		let ratingFacade = RatingRequestsFacade()
		ratingFacade.getRequest(typeParams: .estimate(uid: pollUser, ratingId: curretinRQ, efficiency: effeciency, loyalty: loyalty, professionalism: professionalism, discipline: discipline))
		
		WebSocketNetworking.shared.socket.onData = { [weak self] data in
			guard let self = self else { return }
			do {
				let jsonResponse = try JSONDecoder().decode(RatingAnswerOkResponse.self, from: data)
				print("estimateJSON is: \(jsonResponse)")
				
				if jsonResponse.result?.message == "ok" {
					self.alertCommand(title: "Благодарим за отзыв", message: "Оценка засчитана")
					
				}
				
			} catch let error {
				self.alertCommand(title: "Неизвестная ошибка", message: "")
				print("estimatequiz error \(error)")
			}
		}
	}
	
	func gettingUserId() {
		guard let ss = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { return }
		if let id = ss["userId"] as? Int {
			userId = id
		}
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
