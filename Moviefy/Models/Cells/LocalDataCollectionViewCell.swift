//
//  LocalDataCollectionViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 15.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class LocalDataCollectionViewCell: UICollectionViewCell {
    
    private var movie: MovieModel?
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var addedLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var watchedButton: UIButton!
    
    func loadData(from movie: MovieModel) {
        self.movie = movie
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
        if (movie.markedAs != "To-Watch") {
            self.watchedButton.isHidden = true
        }
        else {
            self.watchedButton.isHidden = false
        }
    }
    @IBAction func onTapWatched(_ sender: Any) {
        if let movie = self.movie {
            CoreDataManager.deleteMovie(byId: Int(truncatingIfNeeded: movie.id), markedAs: MovieSectionEndpoint.toWatch)
            CoreDataManager.saveMovie(Movie(withMovieModel: movie), markedAs: MovieSectionEndpoint.watched)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshCollectionView"), object: nil)
        }
    }
    
}
