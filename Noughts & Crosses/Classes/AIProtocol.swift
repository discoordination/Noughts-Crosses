//
//  AIProtocol.swift
//  Noughts & Crosses
//
//  Created by Will W on 12/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//



protocol TicTacToeAiProtocol {
	associatedtype Participant  // Whose turn it is.
	var currentTurnParticipant:Participant { get set }
	var currentBoard:Board { get set }
	var opponentCharacter: String { get }
	var aiCharacter: String { get }
	
	associatedtype Move
	func findBestMove() -> Move?
	func implementMove(ofParticipantWithCharacter character: String, move: Move) throws
	
	associatedtype AIError
}


