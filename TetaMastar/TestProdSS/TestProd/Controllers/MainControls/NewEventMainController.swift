//
//  NewEventMainController.swift
//  TestProd
//
//  Created by Developer on 15/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class NewEventMainController: UIViewController {
	
	
	@IBOutlet weak var tableViewController: UITableView!
	
	var elementsArray = [NewEventElements]()
//	var ratingData = [RatingInMyGroupModel.result]()
	
	var currentGroupId: String?
	var currentOrgId: Int?
	
	var storageGroupId: String?
	var storageOrgId: Int?
	
	let images = UIImage(named: "crown")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		currentGroupId = storageGroupId
		currentOrgId = storageOrgId
		
		tableViewController.delegate = self
		tableViewController.dataSource = self
		elementsInitiate(title: "Оценивание", description: "Какое-то голосование и большое описание 11", image: UIImage.init(named: "crown")!)
		elementsInitiate(title: "Опрос", description: "Какой-то опрос и большое описание 11", image: UIImage.init(named: "crown")!)
		elementsInitiate(title: "Предложение", description: "Какое-то предложение и большое описание 11", image: UIImage.init(named: "crown")!)
//		isRatingNowInMyGroup()
	}
	
	deinit {
		print("newEventMainController deinited")
	}
	
	func elementsInitiate (title: String, description: String, image: UIImage) {
		let data = NewEventElements(title: title, description: description, image: image)
		elementsArray.append(data)
		tableViewController.reloadData()
	}
	
//	func startRating(orgId: Int) {
//		guard let url = URL(string: "http://89.189.159.160:80/api/rating/start/\(orgId)") else { return }
//
//		var request = URLRequest(url: url)
//		request.httpMethod = "GET"
//		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//		let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//			if error != nil {
//				print("errorrrrr startRating: \(String(describing: error))")
//			}
//
//			guard let data = data else { print("startRating error"); return }
//
//			do {
//				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//				print("jsonResponse startrating: \(jsonResponse)")
//
//			} catch let error {
//				print("start rating error: \(error)")
//			}
//		}
//		task.resume()
//	}
	
//	private func isRatingNowInMyGroup() {
//		let ratingRequest = RatingRequestsFacade()
//		ratingRequest.getRequest(typeParams: .isRatingNowInMyGroup)
//		
//		WebSocketNetworking.shared.socket.onData = {[weak self] data in
//			guard let self = self else { return }
//			
//			do {
//				let jsonResponse = try JSONDecoder().decode(RatingInMyGroupModel.self, from: data)
//				print("jsonrespone: \(jsonResponse)")
//				let jsonModel = jsonResponse.result
//				self.ratingData = jsonModel
//				
//			} catch let error {
//				print("isRatingNowInMyGroup errror:\(error)")
//			}
//			
//		}
//	}
	
}

extension NewEventMainController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCellId", for: indexPath) as? NewEventCell {
			cell.titleLabel.text = elementsArray[indexPath.row].title
			cell.descriptionLabel.text = elementsArray[indexPath.row].description
			cell.imageViewEvent.image = elementsArray[indexPath.row].image
			
			
			return cell
			
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let name = elementsArray[indexPath.row].title
		
		switch name {
		case "Оценивание":
			print("this is golos")
//			guard let curOrgId = currentOrgId else { return }
//			startRating(orgId: curOrgId)
			
//			let alertController = UIAlertController(title: "", message: "Событие началось", preferredStyle: .alert)
//			let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
//				self.navigationController?.popViewController(animated: true)
//			}
//			alertController.addAction(okAction)
//			present(alertController, animated: true, completion: nil)
			
		case "Опрос":
			print("this is opros")
			//			let pollView = storyboard?.instantiateViewController(withIdentifier: "pollView") as? PollViewController
			//			navigationController?.pushViewController(pollView!, animated: true)
			
		case "Предложение":
			print("this is predloz")
			//			let offerView = storyboard?.instantiateViewController(withIdentifier: "offerView") as? OfferViewController
			//			navigationController?.pushViewController(offerView!, animated: true)
			
		default: break
		}
		
		
	}
	
	
	
}
