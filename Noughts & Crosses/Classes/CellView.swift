//
//  CellView.swift
//  Noughts & Crosses
//
//  Created by Will W on 10/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class CellView: NSView {

	var yPosition = -1, xPosition = -1
	var trackingRectTag: TrackingRectTag!
	
	var reactingToMouseEvents = true {
		didSet {
			animationLayer.reactingToMouseInLayer = reactingToMouseEvents
			if reactingToMouseEvents == false {
				removeTrackingRect(trackingRectTag)
			} else {
				trackingRectTag = addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false)}
			setNeedsDisplay(bounds)
		}
	}
	
	var mouseIsInView = false {
		didSet {
			animationLayer.mouseIsInLayerView = mouseIsInView
			setNeedsDisplay(bounds)
		}
	}
	var mouseIsInAxisOfView = false {
		didSet {
			animationLayer.mouseIsInAxisOfLayerView = mouseIsInAxisOfView
			setNeedsDisplay(bounds)
		}
	}
	var animationLayer:BlankShapeLayer!
	
	weak var cellViewMouseDetectorDelegate: ReactsToIndividualCellMouseEvents!
	
	var drawAnimated = true
	
	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)
		if reactingToMouseEvents {
			print("Mouse entered: (\(xPosition), \(yPosition)).")
			if let allViews = superview!.subviews as? [CellView] {
				allViews.forEach{ $0.mouseIsInView = false }
			}
			mouseIsInView = true
			cellViewMouseDetectorDelegate.mouseHasEntered(sender: self, withEvent: event)
		}
	}
	
	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)
		print("Mouse exited: (\(xPosition), \(yPosition)).")
		mouseIsInView = false
		cellViewMouseDetectorDelegate.mouseHasExited(sender: self, withEvent: event)
	}
	
	override func viewDidMoveToWindow() {
		trackingRectTag = addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
	}
	
	override func layout() {
		super.layout()
		removeTrackingRect(trackingRectTag)
		trackingRectTag = addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
	}
	
	override var wantsUpdateLayer: Bool {
		return true
	}
}
