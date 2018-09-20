//
//  TopView.swift
//  Noughts & Crosses
//
//  Created by Will W on 04/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa


class TopView: NSView, NSTextFieldDelegate {
	
	var textField:NSTextField!
	var shadowField:NSTextField!
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		CGColor.MyColour.backgroundColour.nsColor.setFill()
		dirtyRect.fill(using: .sourceOver)
		
		let bottomLine = NSBezierPath()
		bottomLine.move(to: CGPoint(x: 0, y: 0))
		bottomLine.line(to: CGPoint(x: self.bounds.width, y: 0))
		bottomLine.lineWidth = 4
		CGColor.MyColour.borderColour.nsColor.setStroke()
		bottomLine.stroke()
	}
	
	override func layout() {
		super.layout()

		let font = NSFont(name: textField.font!.fontName,
						  size: bounds.height > 60 ? bounds.height / 2.0 : 30.0)
		textField.font = font
		shadowField.font = font
	}
}
