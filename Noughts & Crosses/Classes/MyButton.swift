//
//  MyButton.swift
//  Noughts & Crosses
//
//  Created by Will W on 11/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

class MyButton: NSButton {

	override var wantsLayer: Bool {
		get { return true }
		set {  }
	}
	
	override func updateLayer() {
		//cell?.backgroundStyle = .light
		if !cell!.isHighlighted {
			
		} else {
			//cell
		}
		//layer?.backgroundColor = CGColor.black.copy(alpha: 0.4)
		//cell.color
	}
}
