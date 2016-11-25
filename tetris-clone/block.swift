//
//  block.swift
//  tetris-clone
//
//  Created by Sven Forstner on 28.10.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.
//

import Foundation

import SpriteKit


let NumberOfColors: UInt32 = 6


enum BlockColor: Int, CustomStringConvertible {
    
    
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue@2x"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    
    var description: String {
        return self.spriteName
    }
    
    
    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
    
   
    
}

class Block: Hashable, CustomStringConvertible {
    // #8
    // Constants
    let color: BlockColor
    
    // #9
    // Properties
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    // #10
    var spriteName: String {
        return color.spriteName
    }
    
    // #11
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // #12
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

// #13
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}

