//
//  SearchMovieCollectionViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchMovieCollectionViewCell: UICollectionViewCell {
    
    private var movie: Movie?
    
    @IBOutlet var backdropImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    func loadData(movie: Movie) {
        self.movie = movie
        self.backdropImage.image = movie.thumbnail
        self.titleLabel.text = movie.title
    }
    
    func getMovie() -> Movie? {
        return movie
    }
    
}
