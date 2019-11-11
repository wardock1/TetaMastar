//
//  CreateOrganizationViewController.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 06/11/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class CreateOrganizationViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var avatar: UIImageView!
	
	let orgRequestsFacade = OrganizationRequestsFacade()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setDecorateToButtons()
		
//		self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
	@IBAction func createButtonTapped(_ sender: UIButton) {
		guard let title = titleTextField.text else { return }
		guard let description = descriptionTextField.text else { return }
		
		orgRequestsFacade.getRequest(typeParams: .orgCreate(title: title, description: description))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.navigationController?.popToRootViewController(animated: true)
			}
		}
	}
	
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	deinit {
		print("CreateOrganizationViewController deinited")
	}
	
	func setDecorateToButtons() {
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
		
		cancelButton.layer.cornerRadius = 17
		cancelButton.layer.masksToBounds = true
		cancelButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}

}

extension UIImage {
	func toBase64() -> String? {
		guard let imageData = self.pngData() else { return nil }
		
		return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
	}
	
	enum JPEGQuality: CGFloat {
		case lowest  = 0
		case low     = 0.25
		case medium  = 0.5
		case high    = 0.75
		case highest = 1
	}
}

extension String {
//	}
	func ConvertBase64StringToImage() -> UIImage? {
		
		guard let decodeData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
		let image = UIImage(data: decodeData)
		return image
	}
}
