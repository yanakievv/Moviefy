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
    func getMovies(from endpoint: MovieListEndpoint, completion: @escaping (MovieResponse?) -> ())
    func getMovie(id: Int, completion: @escaping (Movie?) -> ())
    func searchMovie(query: String, page: Int, completion: @escaping (MovieResponse?) -> ())
    func getImage(path: String, size: MovieImageSize, completion: @escaping (Data?) -> ())
}

enum MovieListEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
    case topRated = "top_rated"
    case popular = "popular"
    
    var description: String {
        switch self {
        case .nowPlaying: return "Trending"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}

enum MovieImageSize: String {
    case small = "w92"
    case medium = "w185"
    case big = "w500"
    case original = "original"
}
