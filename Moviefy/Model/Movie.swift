//
//  Movie.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String
    
    var posterImage: UIImage? = nil
    var backdropImage: UIImage? = nil
    var thumbnail: UIImage? = nil
    
    init(id: Int, title: String, backdropPath: String?, posterPath: String?, overview: String, voteAverage: Double, voteCount: Int, releaseDate: String) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.overview = overview
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.releaseDate = releaseDate
        MovieStore.interface.getImage(path: self.backdropPath ?? "", size: MovieImageSize.small, completion: {img in
            self.thumbnail = UIImage(data: img!)
        })
        MovieStore.interface.getImage(path: self.backdropPath ?? "", size: MovieImageSize.big, completion: {img in
            self.backdropImage = UIImage(data: img!)
        })
        MovieStore.interface.getImage(path: self.posterPath ?? "", size: MovieImageSize.original, completion: {img in
            self.posterImage = UIImage(data: img!)
        })
    }
}

struct MovieResponse {
    
    var results: NSMutableArray
    
    init(results: NSArray) {
        self.results = NSMutableArray()
        for i in results {
            self.results.add((i as! NSDictionary).toMovie())
        }
    }
    
}

enum MovieKey: String, CaseIterable {
    case id = "id"
    case title = "title"
    case backdropPath = "backdrop_path"
    case posterPath = "poster_path"
    case overview = "overview"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case releaseDate = "release_date"
    
}


