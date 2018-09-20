//
//  SideView.swift
//  Noughts & Crosses
//
//  Created by Will W on 11/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class SideView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		
		CGColor.MyColour.backgroundColour.nsColor.setFill()
		dirtyRect.fill(using: .sourceOver)

		let leftLine = NSBezierPath()
		CGColor.MyColour.boardColour.nsColor.setStroke()
		leftLine.move(to: NSPoint(x: 0, y: 0))
		leftLine.line(to: NSPoint(x: 0, y: bounds.height))
		leftLine.lineWidth = 4
		leftLine.stroke()
    }
}
