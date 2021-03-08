//
//  MovieService.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit

protocol MovieService {
    func getMovies(from endpoint: MovieListEndpoint, page: Int, completion: @escaping (MoviesResponse?) -> ())
    func getMovie(id: Int, completion: @escaping (MovieResponse?) -> ())
    func searchMovie(query: String, page: Int, completion: @escaping (MoviesResponse?) -> ())
    func getImage(path: String, size: MovieImageSize, completion: @escaping (Data?) -> ())
}

enum MovieListEndpoint: String, CaseIterable {
    case popular = "popular"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming = "upcoming"

    
    var description: String {
        switch self {
        case .popular: return "Popular"
        case .nowPlaying: return "Trending"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        }
    }
}

enum MovieImageSize: String {
    case small = "w92"
    case medium = "w185"
    case big = "w500"
    case original = "original"
}
