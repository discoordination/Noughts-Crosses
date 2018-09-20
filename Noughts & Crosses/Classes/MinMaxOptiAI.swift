//
//  NoughtsCrossesModel.swift
//  Noughts & Crosses
//
//  Created by Will W on 04/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Foundation

/**
 *MinMaxAI*
 - important: - This is a minMax implementation which uses the board class and returns ai moves.
*/

fileprivate func print(_: String, terminator: String="\n") {}


class MinMaxOptiAI : BaseAI {

	
	private func minMax(board: Board, depth: Int, isMax: Bool) -> Int {
		
		var board = board
		let result = board.evaluate()
		print("Depth = \(depth) Result of this move is: \(result)")
		if result == Board.Result.Win((aiCharacter,[(x:Int,y:Int)]())) { print("Returning 10.\n");return 10 - depth }
		if result == Board.Result.Win((opponentCharacter,[(x:Int,y:Int)]())) { print("Returning -10.\n");return depth - 10 }
		if result == Board.Result.Draw { print("Returning 0.\n");return 0 }
		
		if isMax {
			
			let uniqueMoves = board.getUniqueMoves(whereMoveTokenIs: aiCharacter)
			var best = Int.min
			
			for move in uniqueMoves {
				board[move.y][move.x].0 = aiCharacter == "X" ? 1 : -1
				best = max(minMax(board: board, depth: depth + 1, isMax: !isMax), best)
				board[move.y][move.x].0 = 0
			}
			return best
			
		} else {
			
			let uniqueMoves = board.getUniqueMoves(whereMoveTokenIs: opponentCharacter)
			var best = Int.max
			
			for move in uniqueMoves {
				board[move.y][move.x].0 = opponentCharacter == "X" ? 1 : -1
				best = min(minMax(board: board, depth: depth + 1, isMax: !isMax), best)
				board[move.y][move.x].0 = 0
			}
			return best
		}
	}
	
	override func findBestMove() -> Move? {
		var board = currentBoard
		var bestVal = Int.min
		var bestMove: Move? = nil
		
		let uniqueMoves = board.getUniqueMoves(whereMoveTokenIs: aiCharacter)
		if !uniqueMoves.isEmpty {
			for move in uniqueMoves {
				board[move.y][move.x].0 = aiCharacter == "X" ? 1 : -1
				let moveVal = minMax(board: board, depth: 0, isMax: false)
				board[move.y][move.x].0 = 0
				if moveVal > bestVal {
					bestVal = moveVal
					bestMove = move
				}
			}
		}
		return bestMove
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

