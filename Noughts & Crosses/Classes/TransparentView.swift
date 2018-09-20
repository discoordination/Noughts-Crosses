//
//  TransparentView.swift
//  Noughts & Crosses
//
//  Created by Will W on 14/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class TransparentView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

		NSColor.clear.setFill()
        dirtyRect.fill()
    }
    
}
