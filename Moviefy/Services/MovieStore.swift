//
//  MovieStore.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation

class MovieStore: MovieService {
    
    func getMovies(from endpoint: MovieListEndpoint, completion: @escaping (MovieResponse?) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            NSLog("E: MovieStore -- getMovies url error")
            return
        }
        loadAndDecodeURL(url: url, completion: {(data, urlResponse, error) in
            if (error != nil) {
                NSLog("E: MovieStore -- loadAndDecodeURL error != nil")
                completion(nil)
                return
            }
            if (data == nil || urlResponse == nil) {
                NSLog("E: MovieStore -- data/response returned nil")
                completion(nil)
                return
            }
            let responseString = String(data: data!, encoding: .utf8)!
            let dict = responseString.toDictionary()
            let results = dict.value(forKeyPath: "results") as? NSArray
            let response: MovieResponse = MovieResponse(results: results!)
            completion(response)
        })
        
    }
    
    func getMovie(id: Int, completion: @escaping (Movie?) -> ()) {
        //TODO
        return
    }
    
    func searchMovie(query: String, completion: @escaping (MovieResponse?) -> ()) {
        //TODO
        return
    }
    
    
    static let interface = MovieStore()
    private init() {}
    
    private let APIKey = "258b74537c6968d6d22a734e2994e3ee"
    private let baseURL = "https://api.themoviedb.org/3"
    private let sessionURL = URLSession.shared
    //private let jsonDecoder = Util.jsonDecoder
    
    // The sources that I've checked use some kind of a jsonDecoder, I didn't succeed in making it work so I just parsed the data manually
    // Im still leaving it here for future comments on how to make it work or remove it completely
    
    private func loadAndDecodeURL(url: URL, params: [String:String]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        var queryItems = [URLQueryItem(name: "api_key", value: APIKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value)} )
        }
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            return
        }
        
        sessionURL.dataTask(with: finalURL) { (data, response, error) in
            if (error != nil) {
                NSLog("E: MovieStore -- dataTask error")
                completion(nil, nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                NSLog("E: MovieStore -- httpResponse error")
                completion(nil, response, error)
                return
            }
            if (httpResponse.statusCode < 200 && httpResponse.statusCode >= 300) {
                NSLog("E: MovieStore -- httpResponse <200 >300")
                completion(nil, response, error)
                return
            }
            guard let data = data else {
                NSLog("E: MovieStore -- data error")
                completion(nil, response, error)
                return
            }

            completion(data, response, error)
            
        }.resume()
    }
}
