//
//  BlankShapeLayer.swift
//  Noughts & Crosses
//
//  Created by Will W on 16/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa


extension NSBezierPath {
	
	var cgPath: CGPath {
		let path = CGMutablePath()
		
		var points = [CGPoint](repeating: .zero, count: 3)
		for i in 0..<self.elementCount {
			let type = self.element(at: i, associatedPoints: &points)
			switch type {
			case .moveTo: path.move(to: points[0])
			case .lineTo: path.addLine(to: points[0])
			case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
			case .closePath: path.closeSubpath()
			}
		}
		return path
	}
}


class BlankShapeLayer: CAShapeLayer {
	
	var mouseIsInLayerView = false
	var mouseIsInAxisOfLayerView = false
	var reactingToMouseInLayer = true
	
	func draw() {
		if mouseIsInLayerView && reactingToMouseInLayer {
			superlayer?.backgroundColor = CGColor.MyColour.emptyTargetedColour
		} else if mouseIsInAxisOfLayerView  && reactingToMouseInLayer {
			superlayer?.backgroundColor = CGColor.MyColour.alignedWithChoiceColour
		} else {
			superlayer?.backgroundColor = .clear
		}
	}
	
	
}
