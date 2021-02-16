//
//  DetailsViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 12.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {
    private var movie: Movie!
    
    @IBOutlet var backdropImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewContentLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    
    func prepareData(movie: Movie!) {
        self.movie = movie
        self.navigationItem.title = movie.title
    }
    
    func loadLabels(movie: Movie!) {
        self.titleLabel.text = movie.title
        self.scoreLabel.text = "Score: " + String(movie.voteAverage) + "/10"
        self.votesLabel.text = "Votes: " + String(movie.voteCount)
        self.dateLabel.text = "Release: " + movie.releaseDate
        self.overviewContentLabel.text = movie.overview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backdropImage.image = self.movie.backdropImage
        self.posterImage.image = self.movie.posterImage
        self.loadLabels(movie: self.movie)
    }
}
