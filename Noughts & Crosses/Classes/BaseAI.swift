//
//  BaseAI.swift
//  Noughts & Crosses
//
//  Created by Will W on 18/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Foundation

class BaseAI : NSObject, TicTacToeAiProtocol {
	
	enum Participant:String { case aiOpponent, AI }
	typealias Move = (x: Int, y: Int)
	
	class AIError: Error {
		
		let localizedDescription: String
		
		init(description: String) {
			localizedDescription = description
		}
	}
	
	@objc dynamic var currentTurnParticipantRaw : String = "" // This is observed by vc.
	var currentTurnParticipant : Participant { didSet {
		currentTurnParticipantRaw = currentTurnParticipant.rawValue
		}}
	
	var currentBoard = Board()
	let opponentCharacter: String
	var aiCharacter: String {
		return opponentCharacter == "X" ? "O" : "X"
	}
	
	private let playerMovesFirst: Bool
	
	required init(playerCharacter: String, playerMovesFirst: Bool) {
		self.opponentCharacter = playerCharacter
		self.playerMovesFirst = playerMovesFirst
		self.currentTurnParticipant = playerMovesFirst ? .aiOpponent : .AI
	}
	
	func findBestMove() -> Move? {
		fatalError("Must be overridden")
	}
	
	func implementMove(ofParticipantWithCharacter character: String, move: (x: Int, y: Int)) throws {
		fatalError("Must be overridden")
	}
}
