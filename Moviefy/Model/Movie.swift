//
//  Movie.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit

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

struct MoviesResponse: Codable {
    
    var results: [MovieResponse]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    /*enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
        
    }*/
    
    /*init(results: [MovieResponse]) {
        self.results = [MovieResponse]()
        for i in results {
            self.results.append(i)
        }
    }*/
    
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


