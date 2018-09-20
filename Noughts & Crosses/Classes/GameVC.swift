//
//  ViewController.swift
//  Noughts & Crosses
//
//  Created by Will W on 23/07/2018.
//  Copyright © 2018 Will W. All rights reserved.
//


import Cocoa

protocol GameDataSource : AnyObject {
	func getBoardData() -> Board
	func isPlayerTurn() -> Bool
	var playerCharacter:String { get }
}

protocol ReactsToClickInBlankCell : AnyObject {
	func mouseClickedInBlankCell(withEvent event: NSEvent, inCell cell: BlankView)
}



class GameVC: NSViewController {
	
	struct MenuItemTitle {
		struct PlayerTokenSelectionMenu {
			static let XSelected = "Player is X"
			static let OSelected = "Player is O"
		}
		struct MovesFirstMenu {
			static let PlayerMoveFirst = "Player Moves First"
			static let AIMovesFirst = "AI Moves First"
		}
	}
	
	@IBOutlet weak var topView: TopView!
	@IBOutlet weak var topText: NSTextField!
	@IBOutlet weak var topShadowText: NSTextField!
	
	@IBOutlet weak var boardView: BoardView! {
		didSet {
			boardView.boardDataSource = self
		}
	}

	@IBOutlet weak var turnInfoLabel: NSTextField!
	@IBOutlet weak var aiTurnSpinner: NSProgressIndicator! 
	@IBOutlet weak var playerTokenSelectionMenu: NSPopUpButton!
	@IBOutlet weak var playerMovesFirstSelectionMenu: NSPopUpButton!
	

	@IBAction func resetButtonPressed(_ sender: NSButton) {
		initialiseGame()
	}
	
	private struct AIType {
		let type:Any.Type
		let description:String
	}
	private let AIs = [AIType(type: MinMaxOptiAI.self, description: "MinMaxOptiAI"),
			   AIType(type: RandomAI.self, description: "RandomAI"),
			   AIType(type: BrokenAI.self, description: "BrokenAI")]
	@IBOutlet weak var AISelectionMenu: NSPopUpButton! {
		didSet {
			AISelectionMenu.addItems(withTitles: AIs.map{$0.description})
		}
	}
	
	@objc var ai: BaseAI!
	var currentAIType:BaseAI.Type = MinMaxOptiAI.self
	var playerToken : String!
	var aiToken : String!
	var playerTurn: Bool {
		get { return ai.currentTurnParticipant == .aiOpponent }
		set { ai.currentTurnParticipant = newValue == true ? .aiOpponent : .AI }
	}
	var isObservingAITurn = false
	
	var board = Board() {
		didSet {
			boardView.setNeedsDisplay(boardView.bounds)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		topView.textField = topText
		topView.shadowField = topShadowText
		initialiseGame(newGame: true)
    }
	
	
	override func viewWillAppear() {
		super.viewWillAppear()
		view.window?.appearance = NSAppearance(named: .vibrantDark)
	}
}


extension GameVC /* Move Functions */ {
	
	
	private func initialiseGame(newGame:Bool = false) {
		
		playerToken = playerTokenSelectionMenu.titleOfSelectedItem == MenuItemTitle.PlayerTokenSelectionMenu.XSelected ? "X" : "O"
		aiToken = playerToken == "X" ? "O" : "X"
		
		currentAIType = AIs.first(where: {$0.description == AISelectionMenu.item(at: 0)!.title})!.type as! BaseAI.Type
		
		if !firstTurn {
			removeObserver(self, forKeyPath: #keyPath(ai.currentTurnParticipantRaw))
		}
		ai = currentAIType.init(playerCharacter: playerToken, playerMovesFirst: newGame ? true : playerTurn)
		addObserver(self, forKeyPath: #keyPath(ai.currentTurnParticipantRaw),
					options: [.new, .initial], context: nil)
		
		playerTurn = playerMovesFirstSelectionMenu.titleOfSelectedItem == MenuItemTitle.MovesFirstMenu.PlayerMoveFirst ? true : false
		
		board = ai.currentBoard
		boardView.gameOver = false
		boardView.scratchOutView.removeFromSuperview()
		boardView.scratchOutView = ScratchOutView()
		
		if ai.currentTurnParticipant == .AI {
			disableMouseForBoard()
			doAIMove()
		}
	}
	
	
	@objc func actOnResult() {
		
		let result = board.evaluate()
		
		if result == Board.Result.Win((player: playerToken, moves: [])) {
			var cells = [CellView]()
			if case let .Win((_, movesCoord)) = result {
				cells = movesCoord.map{ boardView.subviews[$0.y * 3 + $0.x]} as! [CellView]
				boardView.gameOver = true
				disableMouseForBoard()
				aiTurnSpinner.stopAnimation(self)
				turnInfoLabel.stringValue = "Game Over\nYou won"
				
				CATransaction.begin()
				CATransaction.setCompletionBlock({
					self.performSegue(withIdentifier: SegueIdentifier.toEndVCSeguePlayerWin, sender: self)
				})
				boardView.drawScratchOutView(throughCells: cells)
				CATransaction.commit()
			}
		} else if result == Board.Result.Win((player: aiToken, moves: [])) {
			var cells = [CellView]()
			if case let .Win((_, movesCoord)) = result {
				cells = movesCoord.map{ boardView.subviews[$0.y * 3 + $0.x]} as! [CellView]
				boardView.gameOver = true
				disableMouseForBoard()
				aiTurnSpinner.stopAnimation(self)
				turnInfoLabel.stringValue = "Game Over\nAI won"
				
				CATransaction.begin()
				CATransaction.setCompletionBlock({
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7, execute: {
						self.performSegue(withIdentifier: SegueIdentifier.toEndVCSegueAIWin, sender: self)

					})
				})
				
				boardView.drawScratchOutView(throughCells: cells)
				CATransaction.commit()
			}
		} else if result == Board.Result.Draw {
			boardView.gameOver = true
			self.aiTurnSpinner.stopAnimation(self)
			self.turnInfoLabel.stringValue = "Game Over\nDraw"
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8, execute: {
				self.performSegue(withIdentifier: SegueIdentifier.toEndVCSegueDraw, sender: self)
				self.disableMouseForBoard()
			})
		}
	}
	
	
	@objc func doAIMove() {
		
		DispatchQueue.global(qos: .userInitiated).async {
			let computermove = self.ai.findBestMove()
			if computermove != nil {
				do {
					try self.ai.implementMove(ofParticipantWithCharacter: self.aiToken, move: computermove!)
				} catch {}
			}
			DispatchQueue.main.async {
				self.board = self.ai.currentBoard
				if self.board.evaluate() != Board.Result.NotFinished {
					self.boardView.setNeedsDisplay(self.boardView.bounds)
					self.actOnResult()
					return
				}
			}
		}
	}
	
	func doPlayerMove(x:Int, y: Int) {
		do {
			try ai.implementMove(ofParticipantWithCharacter: playerToken, move: (x: x, y: y))
			board = ai.currentBoard
			if board.evaluate() != Board.Result.NotFinished {
				self.perform(#selector(self.actOnResult),
							 with: nil,
							 afterDelay: 1.0)
			}
		} catch { print("Error") }
	}
}


extension GameVC /* Disable Mouse input */ {
	
	func disableMouseForBoard() { boardView.reactingToMouseEvents = false }
	func enableMouseForBoard() { boardView.reactingToMouseEvents = true }
	
}


extension GameVC : GameDataSource {
	var playerCharacter: String {
		return ai.opponentCharacter
	}
	
	func isPlayerTurn() -> Bool {
		return ai.currentTurnParticipant == .aiOpponent
	}
	
	
	func getBoardData() -> Board {
		return board
	}
}

extension GameVC : ReactsToClickInBlankCell {
	func mouseClickedInBlankCell(withEvent event: NSEvent, inCell cell: BlankView) {
		if playerTurn {
			doPlayerMove(x: cell.xPosition, y: cell.yPosition)
			if board.evaluate() == Board.Result.NotFinished {
				perform(#selector(doAIMove), with: nil, afterDelay: 2.0)
			}
		}
	}
}


// Segues
extension GameVC {
	struct SegueIdentifier {
		static let toEndVCSegueDraw = "endOfGameSegueDraw"
		static let toEndVCSeguePlayerWin = "endOfGameSeguePlayerWin"
		static let toEndVCSegueAIWin = "endOfGameSegueAIWin"
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		
		if let destinationVC = segue.destinationController as? EndGameVC {
			destinationVC.sourceController = self
			
			disableMouseForBoard()
			
			switch segue.identifier {
			case SegueIdentifier.toEndVCSegueDraw:
				destinationVC.message = "The Game was a Draw"
			case SegueIdentifier.toEndVCSeguePlayerWin:
				destinationVC.message = "You Win"
			case SegueIdentifier.toEndVCSegueAIWin:
				destinationVC.message = "The AI has won."
			default: print("No")
			}
		}
	}
}


extension GameVC /* KVO Observing */ {
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		
		if keyPath == #keyPath(ai.currentTurnParticipantRaw) {

			guard change != nil else { return }

			if let newValue = change![.newKey] as? String {
				switch newValue {
				case "aiOpponent":
					print("It is your turn")
					
					DispatchQueue.main.async {
						self.enableMouseForBoard()
						self.turnInfoLabel.stringValue = "Your turn"
						self.aiTurnSpinner.stopAnimation(self)
					}
				case "AI":
					DispatchQueue.main.async {
						self.disableMouseForBoard()
						self.turnInfoLabel.stringValue = "AI turn"
						self.aiTurnSpinner.startAnimation(self)
					}
					print("It is AIs turn")

				default: break
				}
			}
		}
	}
}

