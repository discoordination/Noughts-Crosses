//
//  BoardView.swift
//  Noughts & Crosses
//
//  Created by Will W on 04/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Cocoa


extension NSView {
	var center:NSPoint {
		get {
			return NSPoint(x: NSMidX(bounds), y: NSMidY(bounds))
		}
		set {
			setFrameOrigin(NSPoint(x: newValue.x - frame.width / 2 + bounds.origin.x,
								   y: newValue.y - frame.height / 2 + bounds.origin.y))
		}
	}
}


protocol ReactsToIndividualCellMouseEvents: AnyObject {
	func mouseHasEntered(sender: NSView, withEvent: NSEvent)
	func mouseHasExited(sender: NSView, withEvent: NSEvent)
}



/*------------------------------------------------------*/





class BoardView: NSView {

	
	private struct Constants {
		static let Scale:CGFloat = 1.53
	}
	
	weak var boardDataSource: GameDataSource!
	
	private var w:CGFloat { return self.bounds.width }
	private var h:CGFloat { return self.bounds.height }
	private var dim:CGFloat { return min(w, h) }
	private let boardPositionRatios:[(CGFloat,CGFloat)] =
				[ (-2/10,1/5),(0,1/5),(2/10,1/5),
				  (-2/10,0),(0,0),(2/10,0),
				  (-2/10,-1/5),(0,-1/5),(2/10,-1/5)  ]
	
	let scratchLayer = CrossOutShapeLayer()
	var scratchOutView:ScratchOutView = ScratchOutView()
	var boardCells:[CellView] {
		return subviews.filter{$0 is CellView} as! [CellView]
	}
	var drawsScratchOutView:Bool = true
	var gameOver = false
	
	var reactingToMouseEvents = true {
		didSet {
			if let subviews = subviews as? [CellView] {
				subviews.forEach{ $0.reactingToMouseEvents = reactingToMouseEvents }
			}
		}
	}
	
	private func drawBoardOutline() {
		
		self.bounds = self.frame.offsetBy(dx: -w/2, dy: -h/2)
		let boardPath = NSBezierPath()
		
		boardPath.move(to: NSPoint(x: -1/10 * dim * Constants.Scale, y: 3/10 * dim * Constants.Scale))
		boardPath.line(to: NSPoint(x: -1/10 * dim * Constants.Scale, y: -3/10 * dim * Constants.Scale))
		boardPath.move(to: NSPoint(x: 1/10 * dim * Constants.Scale, y: 3/10 * dim * Constants.Scale))
		boardPath.line(to: NSPoint(x: 1/10 * dim * Constants.Scale, y: -3/10 * dim * Constants.Scale))
		boardPath.move(to: NSPoint(x: -3/10 * dim * Constants.Scale, y: -1/10 * dim * Constants.Scale))
		boardPath.line(to: NSPoint(x: 3/10 * dim * Constants.Scale, y: -1/10 * dim * Constants.Scale))
		boardPath.move(to: NSPoint(x: -3/10 * dim * Constants.Scale, y: 1/10 * dim * Constants.Scale))
		boardPath.line(to: NSPoint(x: 3/10 * dim * Constants.Scale, y: 1/10 * dim * Constants.Scale))

		CGColor.MyColour.boardColour.nsColor.setStroke()
		boardPath.lineCapStyle = .round
		boardPath.lineJoinStyle = .round
		boardPath.lineWidth = 4
		boardPath.stroke()
	}
	
	private func getXViewFor(position: CGPoint) -> CellView {
		let newX = XView()
		let dimension = dim / 5 * Constants.Scale
		let offsetPos = CGPoint(x: position.x - dimension / 2, y: position.y - dimension / 2)
		newX.frame = NSRect(origin: offsetPos, size: CGSize(width: dimension, height: dimension))
		newX.needsDisplay = true
		return newX
	}
	private func getOViewFor(position: CGPoint) -> CellView {
		let newO = OView()
		let dimension = dim / 5 * Constants.Scale
		let offsetPos = CGPoint(x: position.x - dimension / 2, y: position.y - dimension / 2)
		newO.frame = NSRect(origin: offsetPos, size: CGSize(width: dimension, height: dimension))
		newO.needsDisplay = true
		return newO
	}
	
	private func getBlankViewFor(position: CGPoint) -> CellView {
		let newBlank = BlankView()
		let dimension = dim / 5 * Constants.Scale
		let offsetPos = CGPoint(x: position.x - dimension / 2, y: position.y - dimension / 2)
		newBlank.frame = NSRect(origin: offsetPos, size: CGSize(width: dimension, height: dimension))
		newBlank.needsDisplay = true
		newBlank.reactsToClickVC = boardDataSource as! GameVC
		return newBlank
	}
	
	private func drawBoardContents() {
		
		let board = boardDataSource.getBoardData()
		let playerCharacter = boardDataSource.playerCharacter
		
		for (index, (pos, offsetRatio)) in zip(board.flatMap({$0}), boardPositionRatios).enumerated() {
		
			var newView:CellView?
			if pos.0 == 1 && !(subviews[index] is XView) {
				newView = getXViewFor(position: CGPoint(x: offsetRatio.0 * dim * Constants.Scale,
														y: offsetRatio.1 * dim * Constants.Scale))
			} else if pos.0 == -1 && !(subviews[index] is OView) {
				newView = getOViewFor(position: CGPoint(x: offsetRatio.0 * dim * Constants.Scale,
														y: offsetRatio.1 * dim * Constants.Scale))
			} else if pos.0 == 0 && !(subviews[index] is BlankView) {
				newView = getBlankViewFor(position: CGPoint(x: offsetRatio.0 * dim * Constants.Scale,
															y: offsetRatio.1 * dim * Constants.Scale))
			}
			
			if let newView = newView {
				newView.cellViewMouseDetectorDelegate = self
				newView.yPosition = index / 3
				newView.xPosition = index % 3
				subviews[index] = newView
				
				if newView is XView {
					if playerCharacter == "X" {
						newView.reactingToMouseEvents = false
					}
				}
				if newView is OView {
					if playerCharacter == "O" {
						newView.reactingToMouseEvents = false
					}
				}
				if gameOver {
					newView.reactingToMouseEvents = false
				}
			}
		}
		setAlignmentAxisColours()
	}
	
	private func redrawBoardContents() {
		
		let board = boardDataSource.getBoardData()
		
		for (index, (_, offsetRatio)) in zip(board.flatMap({$0}), boardPositionRatios).enumerated() {
			let position = NSPoint(x: offsetRatio.0 * dim * Constants.Scale,
								   y: offsetRatio.1 * dim * Constants.Scale)
			let dimension = dim / 5 * Constants.Scale
			let offsetPos = NSPoint(x: position.x - dimension / 2,
									y: position.y - dimension / 2)
			subviews[index].setFrameOrigin(offsetPos)
			subviews[index].setFrameSize(NSSize(width: dimension, height: dimension))
			//subviews[index].setBoundsSize(NSSize(width: dimension, height: dimension))
			subviews[index].layer?.frame.size = subviews[index].bounds.size
			if let xView = subviews[index] as? XView {
				xView.animationLayer.draw()
			}
			if let oView = subviews[index] as? OView {
				oView.animationLayer.draw()
			}
		}
	}
	
	func drawScratchOutView(throughCells cells: [CellView]) {
		
		scratchOutView.frame = self.frame
		scratchOutView.bounds = self.bounds
		scratchOutView.frame.origin = NSPoint(x: self.bounds.minX, y: self.bounds.minY)
		scratchOutView.wantsLayer = true
		scratchOutView.layer?.addSublayer(scratchLayer)
		self.addSubview(scratchOutView)
		//scratchOutView.superview = self
		scratchLayer.drawAnimated(throughCells: cells)
	}
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

		CGColor.MyColour.backgroundColour.nsColor.setFill()
		dirtyRect.fill(using: .sourceOver)
		drawBoardOutline()
		drawBoardContents()
	}
	
	override func layout() {
		redrawBoardContents()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.wantsLayer = true
		for _ in 0..<9 {
			let view = NSView()
			view.isHidden = true
			self.subviews.append(view)
		}
	}
}



extension BoardView : ReactsToIndividualCellMouseEvents {
	
	private func setAlignmentAxisColours() {
		let cellViews = subviews.filter{$0 is CellView} as! [CellView]
		cellViews.forEach{ $0.mouseIsInAxisOfView = false }
		let viewWithPointerInside = cellViews.filter{ $0.mouseIsInView && reactingToMouseEvents }.first
		if let viewWithPointerInside = viewWithPointerInside {
			cellViews.filter{$0 !== viewWithPointerInside && ($0.xPosition == viewWithPointerInside.xPosition || $0.yPosition == viewWithPointerInside.yPosition)}.forEach{$0.mouseIsInAxisOfView = true}
		}
	}
	
	func mouseHasEntered(sender: NSView, withEvent: NSEvent) {
		if (sender as! CellView).reactingToMouseEvents {
			setAlignmentAxisColours()
		}
	}
	
	func mouseHasExited(sender: NSView, withEvent: NSEvent) {
			setAlignmentAxisColours()
	}
}
