//
//  MovieCollectionViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private var movie: Movie?
    @IBOutlet var title: UILabel!

    func loadData(from: Movie?) {
        if let from = from {
            movie = from
            self.setProperties()
        }
        else {
            NSLog("W: MovieCollectionViewCell -- loadData from nil")
        }
    }
    
    func setProperties() {
        title.text = movie?.title
    }
}
