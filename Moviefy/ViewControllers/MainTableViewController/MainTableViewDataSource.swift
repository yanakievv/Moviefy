//
//  MainTableViewDataSource.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 26.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewDataSource: NSObject {
    
    private var popular: MoviesResponse?
    private var trending: MoviesResponse?
    private var topRated: MoviesResponse?
    private var upcoming: MoviesResponse?
    
    private var arrayOfSections = [MoviesResponse?]()
    private var thumbnailsForTitle: [String : UIImage] = [:]
    
    func getMoviesFromSection(_ section: Int) -> [MovieResponse]? {
        if (section >= 0 && section < self.arrayOfSections.count) {
            return self.arrayOfSections[section]?.results
        }
        return nil
    }
    
    func getNumberOfMoviesInSection(_ section: Int) -> Int {
        if (section >= 0 && section < self.arrayOfSections.count) {
            return self.arrayOfSections[section]?.results.count ?? 0
        }
        return 0
    }
    
    func getThumbnailForTitle(_ title: String) -> UIImage? {
        return thumbnailsForTitle[title]
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
        let page = ((arrayOfSections[section]?.results.count ?? 0) / 20) + 1
        MovieStore().getMovies(from: MovieListEndpoint.allCases[section], page: page, completion: { response in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                self.arrayOfSections[section]?.results.append(contentsOf: response.results)
            }
        })
    }
    
    private func loadThumbnails(forMovies movies: [MovieResponse]) {
        movies.forEach({ self.loadThumbnail(movie: $0) })
    }
    
    private func loadThumbnail(movie: MovieResponse) {
        if let backdropPath = movie.backdropPath {
            MovieStore().getImage(path: backdropPath, size: MovieImageSize.small, completion: {img in
                if let img = img {
                    self.thumbnailsForTitle[movie.title] = UIImage(data: img)
                }
                else {
                    self.thumbnailsForTitle[movie.title] = UIImage(named: "no-image.png")
                }
            })
        }
        else {
            self.thumbnailsForTitle[movie.title] = UIImage(named: "no-image.png")
        }
    }
    
    func loadImages(movie: MovieResponse, completion: @escaping (UIImage?, UIImage?) -> ()) {
        var backdrop: UIImage?
        var poster: UIImage?
        if let backdropPath = movie.backdropPath {
            MovieStore().getImage(path: backdropPath, size: MovieImageSize.big, completion: {img in
                if let img = img {
                    backdrop = UIImage(data: img)
                }
                else {
                    backdrop = UIImage(named: "no-image.png")
                }
            })
        }
        else {
            backdrop = UIImage(named: "no-image.png")
        }
        if let posterPath = movie.posterPath {
            MovieStore().getImage(path: posterPath, size: MovieImageSize.original, completion: {img in
                if let img = img {
                    poster = UIImage(data: img)
                }
                completion(backdrop, poster)
            })
        }
        else {
            completion(backdrop, poster)
        }
        // no need to set poster to the "no-image" image, it will just show up as blank and should not mess up the layout
    }
}

extension MainTableViewDataSource: UITableViewDataSource {
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
}
