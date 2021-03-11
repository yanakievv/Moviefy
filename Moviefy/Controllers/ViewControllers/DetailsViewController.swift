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
    
    func prepareData() {
        self.navigationItem.title = self.movie?.data.title ?? "No title"
        self.movie?.loadBackdrop {
            self.backdrop = self.movie?.backdrop
            if (self.isViewLoaded) {
                DispatchQueue.main.async {
                    self.backdropImage.image = self.backdrop
                    self.backdropImage.setNeedsDisplay()
                }
            }
        }
        self.movie?.loadPoster {
            self.poster = self.movie?.poster
            if (self.isViewLoaded) {
                DispatchQueue.main.async {
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
        //self.tabBarController?.tabBar.isHidden = true
        self.setViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tabBarController?.tabBar.isHidden = false
    }
}
