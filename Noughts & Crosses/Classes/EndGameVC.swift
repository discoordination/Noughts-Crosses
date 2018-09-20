//
//  EndGameVC.swift
//  Noughts & Crosses
//
//  Created by Will W on 14/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa


extension NSRect {
	var centre: NSPoint {
		return NSPoint(x: self.midX, y: self.midY)
	}
}



class EndGameVC: NSViewController {

	weak var sourceController:GameVC!
	
	@IBOutlet weak var eventLabel: NSTextField!
	var message:String!
	
	
	@IBAction func restartPressed(_ sender: NSButton) {
		sourceController.resetButtonPressed(sender)
		dismiss(self)
	}
	@IBAction func quitPressed(_ sender: NSButton) {
		dismiss(self)
		NSApplication.shared.terminate(self)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		eventLabel.stringValue = message
		print("Loaded EndgameVC")
    }
	
	override func viewDidLayout() {
		super.viewDidLayout()
		if let window = view.window {
			window.appearance = NSAppearance(named: .vibrantDark)
			window.styleMask = .borderless
			window.isOpaque = false
			window.backgroundColor = .clear
			
			let gameViewRectScreenCoordinates = sourceController.view.window!.convertToScreen(sourceController.view.frame)
			let originPoint = NSPoint(x: gameViewRectScreenCoordinates.midX - window.frame.width / 2, y: gameViewRectScreenCoordinates.midY - window.frame.height / 2 )
			window.setFrameOrigin(originPoint)
		}
	}
}
