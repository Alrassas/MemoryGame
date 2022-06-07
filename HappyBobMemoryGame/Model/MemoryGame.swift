//
//  MemoryGame.swift
//  HappyBobMemoryGame
//
//  Created by shane wirkes on 05.06.22.
//

import UIKit

protocol MemoryGameProtocol {
    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGameDidEnd(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showTiles tiles: [Tile])
    func memoryGame(_ game: MemoryGame, hideTiles tiles: [Tile])
}

class MemoryGame {
    
    var delegate: MemoryGameProtocol?
    var tiles:[Tile] = [Tile]()
    var tilesShown:[Tile] = [Tile]()
    var isPlaying: Bool = false
    
    func newGame(tilesArray:[Tile]) -> [Tile] {
        tiles = shuffleTiles(tiles: tilesArray)
        isPlaying = true
        delegate?.memoryGameDidStart(self)
        return tiles
    }
    
    func restartGame() {
        isPlaying = false
        
        tiles.removeAll()
        tilesShown.removeAll()
    }
    
    func tileAtIndex(_ index: Int) -> Tile? {
        if tiles.count > index {
            return tiles[index]
        } else {
            return nil
        }
    }
    
    func indexForTile(_ tile: Tile) -> Int? {
        for index in 0...tiles.count-1 {
            if tile === tiles[index] {
                return index
            }
        }
        return nil
    }
    
    func didSelectTile(_ tile: Tile?) {
        guard let tile = tile else {return}
        
        delegate?.memoryGame(self, showTiles: [tile])
        
        if unmatchedTileShown() {
            let unmatched = unmatchedTile()!
            
            if tile.equals(unmatched) {
                tilesShown.append(tile)
            } else {
                let secondTile = tilesShown.removeLast()
                
                let delayTime = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.memoryGame(self, hideTiles:[tile, secondTile])
            }
        }
        } else {
            tilesShown.append(tile)
        }
        
        if tilesShown.count == tiles.count {
            endGame()
        }
    }
    
    private func endGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self)
    }
    
    private func unmatchedTileShown() -> Bool {
        return tilesShown.count % 2 != 0
    }
    
    private func unmatchedTile() -> Tile? {
        let unmatchedTile = tilesShown.last
        return unmatchedTile
    }
    
    private func shuffleTiles(tiles:[Tile]) -> [Tile] {
        var randomTiles = tiles
        randomTiles.shuffle()
        return randomTiles
    }
}
