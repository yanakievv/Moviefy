//
//  MovieStore.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit

class MovieStore: MovieService {

    func getMovies(from endpoint: MovieListEndpoint, page: Int = 1, completion: @escaping (MoviesResponse?) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            NSLog("E: func getMovies -- url error")
            return
        }
        loadURL(url: url, params: ["page" : String(page)], completion: {(data, response, error) in
            self.responseCheck(data: data, response: response, error: error, fromMethod: "func getMovies")
            guard let data = data else {
                return
            }
            do {
                let decodedResponse: MoviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                completion(decodedResponse)
            }
            catch {
                NSLog("E: func getMovies -- \(error)")
                completion(nil)
            }
        })
    }
    
    func getMovie(id: Int, completion: @escaping (MovieResponse?) -> ()) {
        //TODO
        return
    }
    
    func searchMovie(query: String, page: Int = 1, completion: @escaping (MoviesResponse?) -> ()) {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            NSLog("E: func searchMovie url error")
            return
        }
        loadURL(url: url, params: ["query" : query, "page" : String(page)], completion: {(data, response, error) in
            self.responseCheck(data: data, response: response, error: error, fromMethod: "func searchMovie")
            guard let data = data else {
                return
            }
            do {
                let decodedResponse: MoviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                completion(decodedResponse)
            }
            catch {
                NSLog("E: func searchMovie -- \(error)")
                completion(nil)
            }
        })
        return
    }
    
    func getImage(path: String, size: MovieImageSize, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: imageBaseURL + size.rawValue + path) else {
            NSLog("E: func getImage -- getPoster url error")
            return
        }
        sessionURL.dataTask(with: url) { (data, response, error) in
            self.responseCheck(data: data, response: response, error: error, fromMethod: "func getImage")
            completion(data)
        }.resume()
    }
    
    private let APIKey = "258b74537c6968d6d22a734e2994e3ee"
    private let baseURL = "https://api.themoviedb.org/3"
    private let imageBaseURL = "https://image.tmdb.org/t/p/"
    private let sessionURL = URLSession.shared
    private let jsonDecoder = Util.jsonDecoder
        
    private func responseCheck(data: Data?, response: URLResponse?, error: Error?, fromMethod: String) {
        if (error != nil) {
            NSLog("E: \(fromMethod) -- Data task error")
            return
        }
        if (data == nil) {
            NSLog("E: \(fromMethod) -- Data is nil")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            NSLog("E: \(fromMethod) -- No HTTP response")
            return
        }
        if (httpResponse.statusCode < 200 && httpResponse.statusCode >= 300) {
            NSLog("E: \(fromMethod) -- HTTP response code: \(httpResponse.statusCode)")
            return
        }
    }
    
    private func loadURL(url: URL, params: [String:String]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
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
            self.responseCheck(data: data, response: response, error: error, fromMethod: "func loadURL")
            completion(data, response, error)
        }.resume()
    }
    
    
}
