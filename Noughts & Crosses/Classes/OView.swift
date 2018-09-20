//
//  OView.swift
//  Noughts & Crosses
//
//  Created by Will W on 05/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class OView: CellView {

	var w:CGFloat { return self.bounds.width }
	var h:CGFloat { return self.bounds.height }
	
	override func updateLayer() {
		
		if drawAnimated {
			(animationLayer as! OShapeLayer).drawAnimated()
			drawAnimated = false
		} else {
			animationLayer.draw()
		}
	}
	
	override func viewWillMove(toSuperview newSuperview: NSView?) {
		wantsLayer = true
		animationLayer = OShapeLayer()
		layer?.addSublayer(animationLayer)
	}

}
