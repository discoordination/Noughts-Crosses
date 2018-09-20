//
//  OShapeLayer.swift
//  Noughts & Crosses
//
//  Created by Will W on 16/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class OShapeLayer: BlankShapeLayer {

	override func draw() -> Void {
		
		let h = superlayer!.bounds.height
		let centre = superlayer!.bounds.centre
		let bezPath = NSBezierPath()
		bezPath.appendArc(withCenter: centre, radius: 4/5 * h / 2, startAngle: 450, endAngle: 90, clockwise: true)
		//bezPath.appendOval(in: self.bounds.insetBy(dx: 1/10 * h, dy: 1/10 * h))
		
		lineWidth = 8
		strokeColor = CGColor.MyColour.noughtsColour
		fillColor = .clear
		path = bezPath.cgPath
		
		if mouseIsInLayerView && reactingToMouseInLayer  {
			superlayer?.backgroundColor = CGColor.MyColour.notEmptyTargetedColour
		} else if mouseIsInAxisOfLayerView && reactingToMouseInLayer  {
			superlayer?.backgroundColor = CGColor.MyColour.alignedWithChoiceColour
		} else {
			superlayer?.backgroundColor = .clear
		}
	}

	func drawAnimated() -> Void {
		draw()
		
		let duration = CFTimeInterval(0.45)
		
		let drawAnim = CABasicAnimation(keyPath: #keyPath(strokeEnd))
		drawAnim.fromValue = 0
		drawAnim.toValue = 1
		drawAnim.beginTime = 0
		drawAnim.duration = duration
		drawAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		drawAnim.fillMode = CAMediaTimingFillMode.forwards
		
		strokeEnd = 1
		
		add(drawAnim, forKey: "drawO")
	}
}
