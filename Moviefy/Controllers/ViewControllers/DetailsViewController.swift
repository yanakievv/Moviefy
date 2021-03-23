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
    var movie: Movie?
    private var backdrop: UIImage?
    private var poster: UIImage?
    
    @IBOutlet var backdropImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewContentLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var toWatchButton: UIButton!
    @IBOutlet var watchedButton: UIButton!
    

    
    func prepareData() {
        self.navigationItem.title = self.movie?.data.title ?? "No title"
        self.movie?.loadBackdrop {
            self.backdrop = self.movie?.backdrop
                DispatchQueue.main.async {
                    if (self.isViewLoaded) {
                        self.backdropImage.image = self.backdrop
                        self.backdropImage.setNeedsDisplay()
                    }
                }
        }
        self.movie?.loadPoster {
            self.poster = self.movie?.poster
            DispatchQueue.main.async {
                if (self.isViewLoaded) {
                    self.posterImage.image = self.poster
                    self.posterImage.setNeedsDisplay()
                }
            }
        }
    }
    
    func setViews() {
        guard let movie = self.movie else {
            self.titleLabel.text = "Unknown"
            self.scoreLabel.text = "N/A"
            self.votesLabel.text = "0"
            self.dateLabel.text = "Unreleased"
            self.overviewContentLabel.text = "No overview"
            return
        }
        self.titleLabel.text = movie.data.title
        self.scoreLabel.text = "Score: " + String(movie.data.voteAverage) + "/10"
        self.votesLabel.text = "Votes: " + String(movie.data.voteCount)
        if (movie.data.releaseDate != nil && movie.data.releaseDate != "") {
            self.dateLabel.text = "Release: " + movie.data.releaseDate!
        }
        else {
            self.dateLabel.text = "Unreleased"
        }
        if (movie.data.overview == "") {
            self.overviewContentLabel.text = "No overview available."
        }
        else {
            self.overviewContentLabel.text = movie.data.overview
        }
        self.backdropImage.image = self.backdrop
        self.posterImage.image = self.poster
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onTapFavourite(_ sender: Any) {
        self.favouriteButton.deployScaleButtonAnimation()
        if let movie = self.movie {
            CoreDataManager.saveMovie(movie, markedAs: MovieSectionEndpoint.favourite)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshCollectionView"), object: nil)
        }
    }
    @IBAction func onTapToWatch(_ sender: Any) {
        self.toWatchButton.deployScaleButtonAnimation()
        if let movie = self.movie {
            CoreDataManager.saveMovie(movie, markedAs: MovieSectionEndpoint.toWatch)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshCollectionView"), object: nil)
        }
    }
    @IBAction func onTapWatched(_ sender: Any) {
        self.watchedButton.deployScaleButtonAnimation()
        if let movie = self.movie {
            CoreDataManager.saveMovie(movie, markedAs: MovieSectionEndpoint.watched)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshCollectionView"), object: nil)
        }
    }
    
}
