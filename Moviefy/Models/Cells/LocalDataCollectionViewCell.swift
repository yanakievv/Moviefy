//
//  LocalDataCollectionViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 15.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class LocalDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var addedLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    func loadData(from movie: MovieModel) {
        if let thumbnailData = movie.thumbnail {
            self.thumbnail.image = UIImage(data: thumbnailData)
        }
        else {
            self.thumbnail.image = UIImage(named: "no-image.png")
        }
        self.titleLabel.text = movie.title
        self.releaseLabel.text = "Release: \(movie.releaseDate ?? "Unreleased")"
        self.addedLabel.text = "Added \(movie.dateAdded ?? "Unknown")"
        self.categoryLabel.text = "★ \(movie.markedAs ?? "Saved")"
    }
    
}
