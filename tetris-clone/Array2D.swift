//
//  Array2D.swift
//  tetris-clone
//
//  Created by Sven Forstner on 23.10.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.
//

import Foundation

// #1
class Array2D<T> {
    let columns: Int
    let rows: Int
    // #2
    var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        // #3
        array = Array<T?>(repeating: nil, count:rows * columns)
    }
    
    // #4
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
