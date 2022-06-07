//
//  TileCollectionViewCell.swift
//  HappyBobMemoryGame
//
//  Created by shane wirkes on 05.06.22.
//

import UIKit

class TileCell: UICollectionViewCell {
    
    static let identifier = "TileCell"
    
    @IBOutlet weak var frontLabelView: UILabel!
    @IBOutlet weak var backLabelView: UILabel!
    
    var tile: Tile? {
        didSet {
            guard let tile = tile else {return}
            frontLabelView.translatesAutoresizingMaskIntoConstraints = false
            frontLabelView.textAlignment = .center
            frontLabelView.font = .systemFont(ofSize: 72, weight: .medium)
            frontLabelView.text = tile.emoji
            frontLabelView.layer.cornerRadius = 5.0
            backLabelView.layer.cornerRadius = 5.0
            frontLabelView.layer.masksToBounds = true
            backLabelView.layer.masksToBounds = true
            NSLayoutConstraint.activate([
                frontLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                frontLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                frontLabelView.topAnchor.constraint(equalTo: contentView.topAnchor),
                frontLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    }
    
    var shown: Bool = false
    
    func showTile(_ show: Bool, animated: Bool) {
        frontLabelView.isHidden = false
        backLabelView.isHidden = false
        
        shown = show
        
        if animated {
            if show {
                UIView.transition(from: backLabelView, to: frontLabelView, duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: {(finished: Bool) -> () in })
            } else {
                UIView.transition(from: frontLabelView,
                                  to: backLabelView, duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubviewToFront(frontLabelView)
                backLabelView.isHidden = true
            } else {
                bringSubviewToFront(backLabelView)
                frontLabelView.isHidden = true
            }
        }
    }
}
