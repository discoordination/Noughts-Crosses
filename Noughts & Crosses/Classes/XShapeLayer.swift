//
//  XShapeLayer.swift
//  Noughts & Crosses
//
//  Created by Will W on 16/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class XShapeLayer: BlankShapeLayer {
	
	override func draw() -> Void {
		
		let w = superlayer!.bounds.width
		let h = superlayer!.bounds.height
		
		let bezPath = NSBezierPath()
		bezPath.move(to: NSPoint(x: 0 + 1/10 * w, y: h - 1/10 * h))
		bezPath.line(to: NSPoint(x: w - 1/10 * w, y: 0 + 1/10 * w))
		bezPath.move(to: NSPoint(x: w - 1/10 * w, y: h - 1/10 * h))
		bezPath.line(to: NSPoint(x: 0 + 1/10 * w, y: 0 + 1/10 * h))
		lineWidth = 8
		lineCap = CAShapeLayerLineCap.round
		strokeColor = CGColor.MyColour.crossesColour
		path = bezPath.cgPath
		
		if mouseIsInLayerView && reactingToMouseInLayer  {
			superlayer?.backgroundColor = CGColor.MyColour.notEmptyTargetedColour
		} else if mouseIsInAxisOfLayerView && reactingToMouseInLayer  {
			superlayer?.backgroundColor = CGColor.MyColour.alignedWithChoiceColour
		} else {
			superlayer?.backgroundColor = .clear
		}
	}
	
	
	func drawAnimated() {
		draw()
		let duration = CFTimeInterval(0.45)
		
		let drawAnim = CABasicAnimation(keyPath: #keyPath(strokeEnd))
		drawAnim.fromValue = 0
		drawAnim.toValue = 1.03
		drawAnim.beginTime = 0
		drawAnim.duration = duration
		drawAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		drawAnim.fillMode = CAMediaTimingFillMode.forwards
		
		strokeEnd = 1
		
		add(drawAnim, forKey: "drawX")
	}
}
