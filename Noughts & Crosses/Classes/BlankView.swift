//
//  BlankView.swift
//  Noughts & Crosses
//
//  Created by Will W on 10/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class BlankView: CellView {

	weak var reactsToClickVC : ReactsToClickInBlankCell!
	
	override func mouseDown(with event: NSEvent) {
		if reactingToMouseEvents {
			reactsToClickVC.mouseClickedInBlankCell(withEvent: event, inCell: self)
		}
	}
	
	override func updateLayer() {
		animationLayer.draw()
	}
	
	override func viewWillMove(toSuperview newSuperview: NSView?) {
		wantsLayer = true
		animationLayer = BlankShapeLayer()
		layer?.addSublayer(animationLayer)
	}
}
