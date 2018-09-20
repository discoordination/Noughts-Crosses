//
//  File.swift
//  Noughts & Crosses
//
//  Created by Will W on 18/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Foundation


class RandomAI : BaseAI {

	
	override func findBestMove() -> Move? {
		return currentBoard.flatMap{$0}.filter{$0.0 == 0}.randomElement()?.1
	}
	
	
	override func implementMove(ofParticipantWithCharacter character: String, move: Move) throws {
		if currentBoard[move.y][move.x].0 == 0 {
			currentBoard[move.y][move.x].0 = character == "X" ? 1 : -1
			currentTurnParticipant = currentTurnParticipant == .aiOpponent ? .AI : .aiOpponent
		} else {
			throw AIError(description: "Invalid move.")
		}
	}
}
