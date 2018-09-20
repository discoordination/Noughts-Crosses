//
//  Colors.swift
//  Noughts & Crosses
//
//  Created by Will W on 04/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa

extension CGColor {
	
	struct MyColour {
		static var backgroundColour: CGColor { return #colorLiteral(red: 0.09313472212, green: 0.1732829944, blue: 0.1590428528, alpha: 1) }
		static var borderColour: CGColor { return #colorLiteral(red: 0.2577064956, green: 1, blue: 0.5012881675, alpha: 1) }
		static var boardColour: CGColor { return  #colorLiteral(red: 0.4228742883, green: 0.7961336224, blue: 0.5218827251, alpha: 1) }
		static var noughtsColour: CGColor { return #colorLiteral(red: 0.5638940884, green: 0.6628314119, blue: 0.9072156599, alpha: 1) }
		static var crossesColour: CGColor { return #colorLiteral(red: 0.9088666268, green: 0.3291914707, blue: 0.366348939, alpha: 1) }
		static var strikeOutColour: CGColor { return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) }
		static var emptyTargetedColour: CGColor { return CGColor(red: 0.1, green: 0.8, blue: 0, alpha: 0.4) }
		static var notEmptyTargetedColour: CGColor { return CGColor(red: 0.8,green: 0.1, blue: 0.1, alpha: 0.4) }
		static var alignedWithChoiceColour: CGColor { return CGColor(red: 0.7, green: 0.7, blue: 0, alpha: 0.4) }
	}
	var nsColor: NSColor {
		return NSColor(cgColor: self)!
	}
}
