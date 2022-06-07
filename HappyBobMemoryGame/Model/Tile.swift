//
//  Tile.swift
//  HappyBobMemoryGame
//
//  Created by shane wirkes on 05.06.22.
//

import UIKit

class Tile {
    
    var id: String
    var visible: Bool = false
    var emoji: String!
    
    static var allTiles = [Tile]()
    
    init(tile: Tile) {
        self.id = tile.id
        self.visible = tile.visible
        self.emoji = tile.emoji
    }
    
    init(emoji: String) {
        self.id = NSUUID().uuidString
        self.visible = false
        self.emoji = emoji
    }
    
    func equals(_ tile: Tile) -> Bool {
        return (tile.id == id)
    }
    
    func copy() -> Tile {
        return Tile(tile: self)
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
