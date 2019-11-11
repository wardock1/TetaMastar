//
//  VoteTableViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 06/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

struct VoteData {
	
	var question = String()
	
	var firstAnswer = String()
	var secondAnswer = String()
	var thirdAnswer = String()
	
	struct Answer {
		
		var firstAnswer = String()
		var secondAnswer = String()
		var thirdAnswer = String()
	}
}

class Question {
	var question : String?
	var answers : [Answer]!
	
	init (question: String, answers: [Answer]) {
		self.question = question
		self.answers = answers
	}
}

class Answer {
	var response: String!
	var returnValue: Int
	
	init(answer: String, returnValue: Int) {
		self.response  = answer
		self.returnValue = returnValue
	}
}


class VoteTableViewController: UITableViewController {
	
	
	var voteList = [VoteData]()
	var questions: [Question]!
	var counter: Int?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.allowsSelection = false
		loadQuestion()
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
				Answer(answer: "", returnValue: 0)
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
				Answer(answer: "Да, предупреждает", returnValue: 1),
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
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return questions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as? VoteTableViewCell {
//			cell.questionLabel.text = voteList[indexPath.row].question
//			cell.firstButton.setTitle(voteList[indexPath.row].firstAnswer, for: .normal)
//			cell.secondButton.setTitle(voteList[indexPath.row].secondAnswer, for: .normal)
//
//			if voteList[indexPath.row].thirdAnswer != "" {
//				cell.thirdButton.setTitle(voteList[indexPath.row].thirdAnswer, for: .normal)
//			} else {
//				cell.thirdButton.isHidden = true
//			}
			
			let currentIndex = indexPath.row
			cell.responsableDelegate = self
			
			let selectedQuestion: Question = questions[indexPath.row]
			cell.questionLabel.text = selectedQuestion.question
			
			if let ss = selectedQuestion.answers[0].response {
				cell.firstButton.setTitle(ss, for: .normal)
			}
			if let ss1 = selectedQuestion.answers[1].response {
				cell.secondButton.setTitle(ss1, for: .normal)
			}
			
			if selectedQuestion.answers[2].response == "" {
				cell.thirdButton.isHidden = true
				print("TRUE ANSWER 2")
			} else {
				cell.thirdButton.isHidden = false
				cell.thirdButton.setTitle(selectedQuestion.answers[2].response, for: .normal)
				print("falsee \(String(describing: selectedQuestion.answers[2].response))")
				print("FALSEEE ANSWER 2")
			}
			
			cell.currentIndexAndResponse(index: currentIndex, currentQuestion: selectedQuestion)
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 230
	}
	
}

extension VoteTableViewController: Responsable {
	func responsable(for index: Int, with response: Int, and question: Question) {
		print("resposnblala: \(index), with: \(response), and and: \(question)")
		
		print("also: \(question.answers[response].returnValue)")
		print("also2: \(String(describing: question.answers[response].response))")
	}
}
