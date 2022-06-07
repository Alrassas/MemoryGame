//
//  HeaderCollectionReusableView.swift
//  HappyBobMemoryGame
//
//  Created by shane wirkes on 09.06.22.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "HeaderCollectionReusableView"
    

    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        let image = UIImage(named: "headerIMG")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    public func configure() {
        backgroundColor = .systemBlue
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

}

