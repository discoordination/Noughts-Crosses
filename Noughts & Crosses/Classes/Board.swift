//
//  Board.swift
//  Noughts & Crosses
//
//  Created by Will W on 09/09/2018.
//  Copyright © 2018 Will W. All rights reserved.
//

import Foundation


struct Board : TicTacToeBoardProtocol {
	
	enum Result : Equatable {
		case Draw, Win((player: String, moves:[(x:Int, y:Int)])), NotFinished
		
		static func ==(lhs: Result, rhs: Result) -> Bool {
			switch (lhs, rhs) {
			case let (.Win((a,_)), .Win((b,_))):
				// Defines win equality to be of same player.
				return a == b
			case (.Draw, .Draw), (.NotFinished, .NotFinished):
				return true
			default:
				return false
			}
		}
	}
	// 0 is blank X is 1 and O is -1
	typealias BoardElem = (Int, (x: Int, y: Int))
	private var array:[[BoardElem]] =
		[[(0, (x:0,y:0)),(0, (x:1,y:0)),(0,(x:2,y:0))],
		 [(0, (x:0,y:1)),(0, (x:1,y:1)),(0,(x:2,y:1))],
		 [(0, (x:0,y:2)),(0, (x:1,y:2)),(0,(x:2,y:2))]]
	
	private var rows:[[BoardElem]] { return array }
	private var cols:[[BoardElem]] { return (0..<3).map{col in array.map{$0[col]}} }
	private var diags:[[BoardElem]] { return [(0..<3).map{ array[$0][$0] }, (0..<3).map{ array[$0][2-$0] }] }
	
	
	init() {}
	
	init(arrayLiteral elements: Board.ArrayLiteralElement...) {
		array = [[BoardElem]]()
		for (y, line) in elements.enumerated() {
			array.append([BoardElem]())
			for (x, elem) in line.enumerated() {
				array[y].append((elem, (x: x,y: y)))
			}
		}
	}
	
	
	func evaluate() -> Result {
		
		for line in rows + cols + diags {
			let first = line.first!.0
			if first == 1 || first == -1 {
				if line.filter({$0.0 == first}).count == 3 {
					return .Win((first == 1 ? "X" : "O", line.map{$0.1}))
				}
			}
		}
		if !areMovesRemaining { return .Draw }
		return .NotFinished
	}
	
	
	var areMovesRemaining: Bool {
		
		for y in 0..<3 {
			for x in 0..<3 {
				if array[y][x].0 == 0 {
					return true
				}
			}
		}
		return false
	}
}


extension Board {
	private func rotatedClockwise(array: [[Int]]) -> [[Int]] {
		return [
			[array[2][0], array[1][0], array[0][0]],
			[array[2][1], array[1][1], array[0][1]],
			[array[2][2], array[1][2], array[0][2]]
		]
	}
	private func rotatedCounterClockwise(array: [[Int]]) -> [[Int]] {
		return [
			[array[0][2], array[1][2], array[2][2]],
			[array[0][1], array[1][1], array[2][1]],
			[array[0][0], array[1][0], array[2][0]]
		]
	}
	
	private func rotated180Degrees(array: [[Int]]) -> [[Int]] {
		return [
			[array[2][2], array[2][1], array[2][0]],
			[array[1][2], array[1][1], array[1][0]],
			[array[0][2], array[0][1], array[0][0]]
		]
	}
	
	private func reflectedInX(array: [[Int]]) -> [[Int]] {
		return [
			[array[0][2], array[0][1], array[0][0]],
			[array[1][2], array[1][1], array[1][0]],
			[array[2][2], array[2][1], array[2][0]]
		]
	}
	
	private func reflectedInY(array: [[Int]]) -> [[Int]] {
		return [
			[array[2][0], array[2][1], array[2][2]],
			[array[1][0], array[1][1], array[1][2]],
			[array[0][0], array[0][1], array[0][2]]
		]
	}
	
	func getUniqueMoves(whereMoveTokenIs token: String) -> [(x:Int, y:Int)] {
		
		let allPossibleMoves = array.flatMap{ $0 }.filter{ $0.0 == 0 }.map{ $0.1 }
		var allUniqueMoves = [(x:Int, y:Int)]()
		var allUniqueResults = [[[Int]]]()
		
		for move in allPossibleMoves {
			var resultingBoard = array.map{ $0.map{ $0.0 } }
			resultingBoard[move.y][move.x] = token == "X" ? 1 : -1
			if !allUniqueResults.contains(rotatedClockwise(array: resultingBoard)) &&
				!allUniqueResults.contains(rotatedCounterClockwise(array: resultingBoard)) &&
				!allUniqueResults.contains(rotated180Degrees(array: resultingBoard)) &&
				!allUniqueResults.contains(reflectedInX(array: resultingBoard)) &&
				!allUniqueResults.contains(reflectedInY(array: resultingBoard)) {
				allUniqueResults += [resultingBoard]
				allUniqueMoves += [move]
			}
		}
		return allUniqueMoves
	}
}

extension Board : ExpressibleByArrayLiteral {
	
	typealias ArrayLiteralElement = [Int]
}

extension Board : Sequence {
	
	var startIndex:Int { return array.startIndex }
	var endIndex:Int { return array.endIndex }
	
	subscript(position: Int) -> [BoardElem] {
		get {
			guard position >= 0 && position < array.count else {
				fatalError("Index is out of range.")
			}
			return array[position]
		}
		set {
			array[position] = newValue
		}
	}
	
	typealias Iterator = Array<[BoardElem]>.Iterator
	typealias Element = Array<[BoardElem]>.Iterator.Element
	
	func makeIterator() -> IndexingIterator<Array<[BoardElem]>> {
		return array.makeIterator()
	}
}

extension Board: CustomStringConvertible {
	var description: String {
		return """
\(array[0].map{String($0.0)}.joined(separator: "|"))\n-+-+-
\(array[1].map{String($0.0)}.joined(separator: "|"))\n-+-+-
\(array[2].map{String($0.0)}.joined(separator: "|"))\n"
"""
	}
}


