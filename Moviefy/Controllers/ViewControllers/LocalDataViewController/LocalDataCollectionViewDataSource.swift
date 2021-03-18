//
//  LocalDataCollectionViewDataSource.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 15.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class LocalDataCollectionViewDataSource: NSObject {
    var movies = [MovieModel]()
        
    func fetchData(fromSection endpoint: MovieSectionEndpoint? = nil) {
        self.movies = CoreDataMovieController.fetchMovies(fromEndpoint: endpoint)
    }
}
extension LocalDataCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocalDataCollectionViewCell",
                                                      for: indexPath) as! LocalDataCollectionViewCell
        
        let movie = self.movies[indexPath.row]
        cell.loadData(from: movie)
        
        return cell
    }
    
    
}
