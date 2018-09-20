//
//  CrossOutShapeLayer.swift
//  Noughts & Crosses
//
//  Created by Will W on 17/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class CrossOutShapeLayer: CAShapeLayer {

	private func isDiagonal(cells: [CellView]) -> Bool {
		if cells.first?.xPosition != cells.last?.xPosition && cells.first?.yPosition != cells.last?.yPosition {
			return true
		}
		return false
	}
	
	private func isVertical(cells: [CellView]) -> Bool {
		return cells.first?.xPosition == cells.last?.xPosition
	}
	
	func drawAnimated(throughCells cells:[CellView]) {
		
		lineWidth = 12
		lineCap = CAShapeLayerLineCap.round
		strokeColor = CGColor.MyColour.strikeOutColour
	
		let bezPath = NSBezierPath()
		
		if isDiagonal(cells: cells) {
			if cells.first?.yPosition == 0 && cells.first?.xPosition == 0 {
			bezPath.move(to: NSPoint(x: cells.first!.frame.minX,
									 y: cells.first!.frame.maxY))
			bezPath.line(to: NSPoint(x: cells.last!.frame.maxX,
									 y: cells.last!.frame.minY))
			} else {
				bezPath.move(to: NSPoint(x: cells.last!.frame.minX,
										 y: cells.last!.frame.minY))
				bezPath.line(to: NSPoint(x: cells.first!.frame.maxX,
										 y: cells.first!.frame.maxY))
			}
		} else if isVertical(cells: cells) {
			bezPath.move(to: NSPoint(x: cells.first!.frame.midX,
									 y: cells.first!.frame.maxY))
			bezPath.line(to: NSPoint(x: cells.last!.frame.midX,
									 y: cells.last!.frame.minY))
		} else {
			bezPath.move(to: NSPoint(x: cells.first!.frame.minX,
									 y: cells.first!.frame.midY))
			bezPath.line(to: NSPoint(x: cells.last!.frame.maxX,
									 y: cells.last!.frame.midY))
		}

		path = bezPath.cgPath
		
		
		let strokeAnimation = CABasicAnimation(keyPath: #keyPath(strokeEnd))
		strokeAnimation.duration = 0.8
		strokeAnimation.beginTime = CACurrentMediaTime() + 0.8
		strokeAnimation.fromValue = 0
		strokeAnimation.toValue = 1
		strokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		strokeAnimation.fillMode = CAMediaTimingFillMode.backwards
		
		strokeEnd = 1
		add(strokeAnimation, forKey: "scratchAnimation")
	}
}
