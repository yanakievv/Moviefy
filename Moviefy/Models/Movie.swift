//
//  Movie.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MovieResponse: Codable {
    
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String?
    
    init(id: Int?, title: String?, backdropPath: String?, posterPath: String?, overview: String?, voteAverage: Double?, voteCount: Int?, releaseDate: String?) {
        self.id = id ?? 0
        self.title = title ?? ""
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.overview = overview ?? ""
        self.voteAverage = voteAverage ?? 0
        self.voteCount = voteCount ?? 0
        self.releaseDate = releaseDate
    }
}

class MoviesResponse: Codable {
    
    var results: [MovieResponse]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
}

class Movie {
    
    let data: MovieResponse
    var thumbnail: UIImage? = nil
    var backdrop: UIImage? = nil
    var poster: UIImage? = nil
    
    init(withMovieResponse movie: MovieResponse) {
        self.data = movie
    }
    
    init(withMovieModel movie: MovieModel) {
        self.data = MovieResponse(id: Int(truncatingIfNeeded: movie.id), title: movie.title, backdropPath: movie.backdropPath, posterPath: movie.posterPath, overview: movie.overview, voteAverage: movie.voteAverage, voteCount: Int(truncatingIfNeeded: movie.voteCount), releaseDate: movie.releaseDate)
    }
    
    func loadThumbnail(completion: @escaping () -> ()) {
        if let backdropPath = data.backdropPath {
            MovieStore().getImage(path: backdropPath, size: MovieImageSize.small, completion: {img in
                if let img = img {
                    self.thumbnail = UIImage(data: img)
                }
                else {
                    self.thumbnail = UIImage(named: "no-image.png")
                }
                completion()
            })
        }
        else {
            self.thumbnail = UIImage(named: "no-image.png")
            completion()
        }
    }
    func loadBackdrop(completion: @escaping () -> ()) {
        if let backdropPath = data.backdropPath {
            MovieStore().getImage(path: backdropPath, size: MovieImageSize.big, completion: {img in
                if let img = img {
                    self.backdrop = UIImage(data: img)
                }
                else {
                    self.backdrop = UIImage(named: "no-image.png")
                }
                completion()
            })
        }
        else {
            self.backdrop = UIImage(named: "no-image.png")
            completion()
        }
    }
    func loadPoster(completion: @escaping () -> ()) {
        
        if let posterPath = data.posterPath {
            MovieStore().getImage(path: posterPath, size: MovieImageSize.original, completion: {img in
                if let img = img {
                    self.poster = UIImage(data: img)
                }
                completion()
            })
        }
        else {
            completion()
        }
        // no need to set poster to the "no-image" image, it will just show up as blank and should not mess up the layout
    }
}



