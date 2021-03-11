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
    
    func loadData(fromMovie movie: Movie) {
        self.titleLabel.text = movie.data.title
        if let img = movie.backdrop {
            self.backdropImage.image = img
        }
    }
}
