//
//  MainTableViewDataSource.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 26.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewDataSource: NSObject {
    
    var tableView: UITableView?
    
    private var popular: [Movie]?
    private var trending: [Movie]?
    private var topRated: [Movie]?
    private var upcoming: [Movie]?
    
    private var arrayOfSections = [[Movie]?]()
    
    func getMoviesFromSection(_ section: Int) -> [Movie]? {
        if (section >= 0 && section < self.arrayOfSections.count) {
            return self.arrayOfSections[section]
        }
        return nil
    }
    
    func getNumberOfMoviesInSection(_ section: Int) -> Int {
        if (section >= 0 && section < self.arrayOfSections.count) {
            return self.arrayOfSections[section]?.count ?? 0
        }
        return 0
    }
        
    func fetchData(completion: @escaping () -> ()) {
        MovieStore().getMovies(from: MovieListEndpoint.popular, completion: { response in
            if let response = response {
                self.popular = response.toArrayOfMovies()
                self.loadThumbnails(forMovies: self.popular, inSection: 0)
                self.arrayOfSections.append(self.popular)
                completion()
            }
        })
        MovieStore().getMovies(from: MovieListEndpoint.nowPlaying, completion: { response in
            if let response = response {
                self.trending = response.toArrayOfMovies()
                self.loadThumbnails(forMovies: self.trending, inSection: 1)
                self.arrayOfSections.append(self.trending)
                completion()
            }
        })
        MovieStore().getMovies(from: MovieListEndpoint.topRated, completion: { response in
            if let response = response {
                self.topRated = response.toArrayOfMovies()
                self.loadThumbnails(forMovies: self.topRated, inSection: 2)
                self.arrayOfSections.append(self.topRated)
                completion()
            }
        })
        MovieStore().getMovies(from: MovieListEndpoint.upcoming, completion: { response in
            if let response = response {
                self.upcoming = response.toArrayOfMovies()
                self.loadThumbnails(forMovies: self.upcoming, inSection: 3)
                self.arrayOfSections.append(self.upcoming)
                completion()
            }
        })
    }
        
    func fetchDataIn(section: Int) {
        let page = ((arrayOfSections[section]?.count ?? 0) / 20) + 1
        MovieStore().getMovies(from: MovieListEndpoint.allCases[section], page: page, completion: { response in
            if let result = response?.toArrayOfMovies() {
                self.loadThumbnails(forMovies: result, inSection: section)
                self.arrayOfSections[section]?.append(contentsOf: result)
            }
        })
    }
    
    private func loadThumbnails(forMovies movies: [Movie]?, inSection section: Int) {
        if let movies = movies {
            let tableViewCell = self.tableView?.cellForRow(at: IndexPath(row: 0, section: section)) as? MainTableViewCell
            for i in 0 ..< movies.count {
                movies[i].loadThumbnail(completion: {
                    DispatchQueue.main.async {
                        tableViewCell?.reloadItems(at: [IndexPath(row: i, section: 0)])
                    }
                })
            }
        }
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
