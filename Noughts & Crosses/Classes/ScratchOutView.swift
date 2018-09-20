//
//  ScratchOutView.swift
//  Noughts & Crosses
//
//  Created by Will W on 14/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class ScratchOutView: NSView {

	var lineWidth : CGFloat = 12
	
	init() {
		super.init(frame: NSZeroRect)
	}
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.wantsLayer = true
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
//		fatalError("init(coder:) has not been implemented for ScratchOutView.")
	}
	
	override var wantsUpdateLayer: Bool {
		return true
	}
}
