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


class BrokenAI : BaseAI {
	
	
	private func minMax(board: Board, depth: Int, isMax: Bool, alpha: Int, beta: Int) -> Int {
		
		var board = board
		let result = board.evaluate()
		print("Depth = \(depth) Result of this move is: \(result)")
		if result == Board.Result.Win((aiCharacter,[(x:Int,y:Int)]())) { print("Returning 10.\n");return 10 - depth }
		if result == Board.Result.Win((opponentCharacter,[(x:Int,y:Int)]())) { print("Returning -10.\n");return -10 + depth }
		if result == Board.Result.Draw { print("Returning 0.\n");return 0 }
		
		
		if isMax {
			let best = Int.min
			
			for y in 0..<3 {
				for x in 0..<3 {
					if board[y][x].0 == 0 {
						print("AI testing (\(x),\(y)) maximiser and computerCharacter.")
						board[y][x].0 = aiCharacter == "X" ? 1 : -1
						let alpha = max(minMax(board: board, depth: depth + 1, isMax: !isMax, alpha: alpha, beta: beta), alpha)
						board[y][x].0 = 0
						if alpha <= beta { return alpha}
					}
				}
			}
			print("Returning best: \(best) from maximiser.")
			return alpha
			
		} else {
			let best = Int.max
			
			for y in 0..<3 {
				for x in 0..<3 {
					if board[y][x].0 == 0 {
						print("AI testing (\(x),\(y)) minimiser and playerCharacter.")
						board[y][x].0 = opponentCharacter == "X" ? 1 : -1
						let beta = min(minMax(board: board, depth: depth + 1, isMax: !isMax, alpha: alpha, beta: beta), beta)
						board[y][x].0 = 0
						if beta >= alpha { return beta }
					}
				}
			}
			print("Returning best: \(best) from minimiser.")
			return beta
		}
	}
	
	override func findBestMove() -> Move? {
		var board = currentBoard
		var bestVal = Int.min
		var bestMove: Move? = nil
		
		for y in 0..<3 {
			for x in 0..<3 {
				if board[y][x].0 == 0 {
					print("\n--------------------------------------")
					print("AI testing (\(x),\(y)) first move.")
					board[y][x] = (aiCharacter == "X" ? 1 : -1,(x:x,y:y))
					let moveVal = minMax(board: board, depth: 0, isMax: false, alpha: Int.min, beta: Int.max)
					print("Move val is \(moveVal).")
					board[y][x] = (0,(x:x,y:y))
					
					if moveVal > bestVal {
						bestVal = moveVal
						print("BestVal updated to: \(bestVal).")
						bestMove = (x: x, y: y)
					}
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

