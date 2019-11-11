//
//  ExtensionUIView.swift
//  TestProd
//
//  Created by Dmitry Kutlyev on 03/08/2019.
//  Copyright © 2019 Dream Team LTD. All rights reserved.
//

import UIKit

extension CALayer {
	
	func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor, colorFourth: UIColor, colorFive: UIColor, colorSix: UIColor) {
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor, colorFourth.cgColor, colorFive.cgColor, colorSix.cgColor]
		gradientLayer.locations = [0.0, 1.0]
		gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
		
		self.addSublayer(gradientLayer)
	}
	
	func setGradienBorder(colors:[UIColor],width:CGFloat = 1) {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame =  bounds
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradientLayer.colors = colors.map({$0.cgColor})
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.lineWidth = width
		shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 17).cgPath
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = UIColor.black.cgColor
		gradientLayer.mask = shapeLayer
		
		self.addSublayer(gradientLayer)
	}
	
	func setGradienBorderForTextField(colors:[UIColor],width:CGFloat = 1) {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame =  bounds
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradientLayer.colors = colors.map({$0.cgColor})
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.lineWidth = width
		shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = UIColor.black.cgColor
		gradientLayer.mask = shapeLayer
		
		self.addSublayer(gradientLayer)
	}
}
