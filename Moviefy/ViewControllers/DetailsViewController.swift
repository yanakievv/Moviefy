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
    private var movie: MovieResponse?
    private var backdrop: UIImage?
    private var poster: UIImage?
    
    @IBOutlet var backdropImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewContentLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    
    func prepareData(movie: MovieResponse?, backdrop: UIImage?, poster: UIImage?) {
        self.movie = movie
        self.navigationItem.title = movie?.title ?? "No title"
        self.backdrop = backdrop
        self.poster = poster
    }
    
    func setLabels() {
        guard let movie = self.movie else {
            self.titleLabel.text = "Unknown"
            self.scoreLabel.text = "N/A"
            self.votesLabel.text = "0"
            self.dateLabel.text = "Unreleased"
            self.overviewContentLabel.text = "No overview"
            return
        }
        self.titleLabel.text = movie.title
        self.scoreLabel.text = "Score: " + String(movie.voteAverage) + "/10"
        self.votesLabel.text = "Votes: " + String(movie.voteCount)
        if (movie.releaseDate != "") {
            self.dateLabel.text = "Release: " + movie.releaseDate
        }
        else {
            self.dateLabel.text = "Unreleased"
        }
        if (movie.overview == "") {
            self.overviewContentLabel.text = "No overview available."
        }
        else {
            self.overviewContentLabel.text = movie.overview
        }
    }
    
    func prepareImages(backdrop: UIImage?, poster: UIImage?) {
        self.backdrop = backdrop
        self.poster = poster
    }
        
    func setImages() {
        if let backdrop = self.backdrop {
            self.backdropImage.image = backdrop
        }
        else {
            self.backdropImage.image = UIImage(named: "no-image.png")
        }
        if let poster = self.poster {
            self.posterImage.image = poster
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.setLabels()
        self.setImages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
