//
//  XView.swift
//  Noughts & Crosses
//
//  Created by Will W on 05/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class XView: CellView {

	var w:CGFloat { return self.bounds.width }
	var h:CGFloat { return self.bounds.height }
	

	override func updateLayer() {
		
		if let animationLayer = animationLayer as? XShapeLayer {
			if drawAnimated {
				animationLayer.drawAnimated()
				drawAnimated = false
			} else {
				animationLayer.draw()
			}
		}
	}
	
	override func viewWillMove(toSuperview newSuperview: NSView?) {
		wantsLayer = true
		animationLayer = XShapeLayer()
		layer?.addSublayer(animationLayer)
	}
}
