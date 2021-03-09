//
//  MovieCollectionViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    
    func loadData(from movie: Movie?) {
        if let image = movie?.thumbnail {
            thumbnailImageView.image = image
        }
        title.text = movie?.data.title ?? ""
    }
    
}
