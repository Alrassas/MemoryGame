//
//  ViewController.swift
//  HappyBobMemoryGame
//
//  Created by shane wirkes on 05.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    typealias TilesArray = [Tile]

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    let game = MemoryGame()
    var tiles = [Tile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        
        getTileEmojis { (tilesArray, error) in
            if let _ = error {
                //show alert
            }
            self.tiles = tilesArray!
            self.setupNewGame()
        }
        
        addConstraints()
            
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func addConstraints() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -405),
        ])
    }
    
    func getTileEmojis(completion: ((TilesArray?, Error?) -> ())?) {
        var tiles = TilesArray()
        let emojiArray = ["💩", "👾", "👽", "👹", "🤖", "🤠", "🥷", "🧚"]
        for emoji in emojiArray {
            let tile = Tile(emoji: emoji)
            let copy = tile.copy()
            
            tiles.append(tile)
            tiles.append(copy)
        }
        
        completion!(tiles, nil)
    }
    
    func setupNewGame() {
        tiles = game.newGame(tilesArray: self.tiles)
        collectionView.reloadData()
    }
    
    func resetGame() {
        game.restartGame()
        setupNewGame()
    }

    @IBAction func onGameStart(_ sender: Any) {
        collectionView.isHidden = false
    }
    
}


// MARK: - CollectionView Delegate Methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath) as! TileCell
        cell.showTile(false, animated: false)
        
        guard let tile = game.tileAtIndex(indexPath.item) else { return cell }
        cell.tile = tile
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TileCell
        
        if cell.shown {return}
        game.didSelectTile(cell.tile)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - MemoryGame Protocol Methods
extension ViewController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGame(_ game: MemoryGame, showTiles tiles: [Tile]) {
        for tile in tiles {
            guard let index = game.indexForTile(tile) else {continue}
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! TileCell
            cell.showTile(true, animated: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideTiles tiles: [Tile]) {
        for tile in tiles {
            guard let index = game.indexForTile(tile) else {continue}
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! TileCell
            cell.showTile(false, animated: true)
        }
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        let alertController = UIAlertController(
            title: "Great Job!",
            message: "Play again?",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Nah", style: .cancel) { [weak self] (action) in
            self?.collectionView.isHidden = true
        }
        
        let playAgainAction = UIAlertAction(title: "Dale!", style: .default) { [weak self] (action) in
            self?.collectionView.isHidden = true
            self?.resetGame()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) { }
        
        resetGame()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = Int(sectionInsets.left) * 4
//        let availableWidth = Int(view.frame.width) - paddingSpace
//        let widthPerItem = availableWidth / 4
//
//        return CGSize(width: widthPerItem, height: widthPerItem)

        let margin: CGFloat = 15
        let size: CGFloat = (collectionView.frame.size.width-margin)/5

        return CGSize(width: size, height: size)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 14,
            left: 14,
            bottom: 4,
            right: 14
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left - 8
    }
}

