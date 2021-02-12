//
//  MovieService.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation

protocol MovieService {
    func getMovies(from endpoint: MovieListEndpoint, completion: @escaping (MovieResponse?) -> ())
    func getMovie(id: Int, completion: @escaping (Movie?) -> ())
    func searchMovie(query: String, completion: @escaping (MovieResponse?) -> ())
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
