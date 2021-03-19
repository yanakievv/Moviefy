//
//  LocalDataCollectionViewDataSource.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 15.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class LocalDataCollectionViewDataSource: NSObject {
    private var movies = [MovieModel]()
    var endpoint: MovieSectionEndpoint?
    
    func getMovie(atIndex index: Int) -> MovieModel? {
        if (index >= 0 && index < movies.count) {
            return movies[index]
        }
        return nil
    }
    
    func fetchData(fromSection endpoint: MovieSectionEndpoint? = nil) {
        self.movies = CoreDataManager.fetchMovies(fromEndpoint: endpoint)
        self.endpoint = endpoint
    }
}
extension LocalDataCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocalDataCollectionViewCell",
                                                      for: indexPath) as! LocalDataCollectionViewCell
        if (indexPath.row < movies.count) {
            let movie = self.movies[indexPath.row]
            cell.loadData(from: movie)
        }
        return cell
    }
    
    
}
