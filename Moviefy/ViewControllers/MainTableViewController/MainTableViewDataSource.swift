//
//  MainTableViewDataSource.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 26.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var popular: MoviesResponse?
    private var trending: MoviesResponse?
    private var topRated: MoviesResponse?
    private var upcoming: MoviesResponse?
    
    var arrayOfSections = [MoviesResponse?]()
    var thumbnailsForTitle: [String : UIImage] = [:]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
            case 0: return "Popular"
            case 1: return "Trending"
            case 2: return "Top Rated"
            case 3: return "Upcoming"
            default: return "Other"
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func fetchData(completion: @escaping () -> ()) {
        MovieStore().getMovies(from: MovieListEndpoint.popular, completion: { response in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                self.popular = response
                self.arrayOfSections.append(self.popular)
                completion()
            }
        })
        MovieStore().getMovies(from: MovieListEndpoint.nowPlaying, completion: { response in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                self.trending = response
                self.arrayOfSections.append(self.trending)
                completion()
            }
        })
        MovieStore().getMovies(from: MovieListEndpoint.topRated, completion: { response in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                self.topRated = response
                self.arrayOfSections.append(self.topRated)
                completion()
            }
        })
        MovieStore().getMovies(from: MovieListEndpoint.upcoming, completion: { response in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                self.upcoming = response
                self.arrayOfSections.append(self.upcoming)
                completion()
            }
        })
    }
    

    
    func fetchDataIn(section: Int) {
        MovieStore().getMovies(from: MovieListEndpoint.allCases[section], page: (((arrayOfSections[section]?.results.count ?? 0) / 20) + 1), completion: { response in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                for movie in response.results {
                    self.arrayOfSections[section]?.results.add(movie)
                }
            }
        })
    }
    
    private func loadThumbnails(forMovies: NSMutableArray) {
        for i in forMovies {
            self.loadThumbnail(movie: i as! MovieResponse)
        }
    }
    
    private func loadThumbnail(movie: MovieResponse) {
        MovieStore().getImage(path: movie.backdropPath ?? "", size: MovieImageSize.small, completion: {img in
            if (movie.backdropPath == nil || movie.backdropPath == "") {
                self.thumbnailsForTitle[movie.title] = UIImage(named: "no-image.png")
            }
            else if let img = img {
                self.thumbnailsForTitle[movie.title] = UIImage(data: img)
            }
        })
    }
    
    func loadImages(movie: MovieResponse, completion: @escaping (UIImage?, UIImage?) -> ()) {
        var backdrop: UIImage?
        var poster: UIImage?
        MovieStore().getImage(path: movie.backdropPath ?? "", size: MovieImageSize.big, completion: {img in
            if (movie.backdropPath == nil || movie.backdropPath == "") {
                backdrop = UIImage(named: "no-image.png")
            }
            else if let img = img {
                backdrop = UIImage(data: img)
            }
            
        })
        MovieStore().getImage(path: movie.posterPath ?? "", size: MovieImageSize.original, completion: {img in
            if let img = img {
                poster = UIImage(data: img)
            }
            completion(backdrop, poster)
        })
    }
}
