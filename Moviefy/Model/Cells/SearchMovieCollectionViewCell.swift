//
//  SearchMovieCollectionViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backdropImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    func loadData(fromMovie movie: MovieResponse, withImage image: UIImage?) {
        self.titleLabel.text = movie.title
        if let img = image {
            self.backdropImage.image = img
        }
    }
}
