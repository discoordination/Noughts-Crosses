//
//  TicTacToeBoardProtocol.swift
//  Noughts & Crosses
//
//  Created by Will W on 12/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

protocol TicTacToeBoardProtocol: Sequence, ExpressibleByArrayLiteral {
	associatedtype Result
	func evaluate() -> Result
	var areMovesRemaining: Bool { get }
}
