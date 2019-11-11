//
//  AddNewGroupController.swift
//  TestProd
//
//  Created by Developer on 11/07/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

class AddNewGroupController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var nameGroupTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var createButton: UIButton!
	
	let groupRequestFacade = GroupFacadeRequests()
	var storageGroupListResult = [NewGroupList.result]()
	
	var storageOrgId: Int?
	var orgId: Int?
	
//	weak var groupListUpdateDelegate: GroupListUpdatable?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        orgId = storageOrgId
        imageViewOutlet.layer.cornerRadius = 0.5 * imageViewOutlet.bounds.size.width
        imageViewOutlet.clipsToBounds = true
        imageViewOutlet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePicker)))
        imageViewOutlet.isUserInteractionEnabled = true
        setDecorationButtons()
		self.hideKeyboardWhenTappedAround()
		nameGroupTextField.delegate = self
		descriptionTextField.delegate = self
    }
	
	deinit {
		print("addNewGroup deinited")
	}
	
	func createNewGroup() {
		guard let title = nameGroupTextField.text, let description = descriptionTextField.text else { return }
		guard let oid = orgId else { return }
//		let orgId = gettingIdOrganization()
//		let parentId = gettingParentGroupId()
//		print("parentId \(parentId)")
//		print("parentId \(orgId)")
		groupRequestFacade.getRequest(typeParams: .createMainGroupByAdmin(organizationId: oid, title: title, description: description))
		
		WebSocketNetworking.shared.socket.onData = {[weak self] data in
			print("createNewGroup")
			guard let self = self else { return }
			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				self.navigationController?.popToRootViewController(animated: true)
				print("jsonResponse createNewGroup: \(jsonResponse)")
				
			} catch let error {
				print("error cretnewgroup: \(error)")
			}
		}
	}
	
	private func gettingIdOrganization() -> Int {
		var idOrganization = 0
		storageGroupListResult.forEach { (result) in
			idOrganization = result.organization.id
		}
		return idOrganization
	}
	
	private func gettingParentGroupId() -> Int {
		var parentIdGroup = 0
		storageGroupListResult.forEach { (result) in
			parentIdGroup = result.id
		}
		print("storageGroupList result id: \(parentIdGroup)")
		print("sam storageGLR: \(storageGroupListResult)")
		return parentIdGroup
	}
	
	func setDecorationButtons() {
		nameGroupTextField.layer.cornerRadius = 6
		nameGroupTextField.layer.masksToBounds = true
		nameGroupTextField.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		
		descriptionTextField.layer.cornerRadius = 6
		descriptionTextField.layer.borderWidth = 1
		descriptionTextField.layer.borderColor = #colorLiteral(red: 0.285771311, green: 0.7863353955, blue: 0.8415880963, alpha: 1)
		
		createButton.layer.cornerRadius = 17
		createButton.layer.masksToBounds = true
		createButton.layer.setGradientBackground(colorOne: Colors.colorOne, colorTwo: Colors.colorTwo, colorThree: Colors.colorThree, colorFourth: Colors.colorFourth, colorFive: Colors.colorFive, colorSix: Colors.colorSix)
	}
    
    @IBAction func createButtonTapped(_ sender: Any) {
		createNewGroup()
//		groupListUpdateDelegate?.updateGroupList()
        navigationController?.popViewController(animated: true)
    }
	
	func hideKeyboard() {
		nameGroupTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
    
    
}


extension AddNewGroupController {
    
    @objc func handlePicker () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        dismiss(animated: true) {
            self.imageViewOutlet.image = pickedImage
        }
    }
}
