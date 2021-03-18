//
//  SearchViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var query: String = ""
    private var page: Int {
        return ((self.movies.count / 20) + 1)
    }
    
    private var movies = [Movie]()
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchData(query: String, completion: @escaping () -> ()) {
        MovieStore().searchMovie(query: query, page: self.page, completion: { response in
            if let result = response?.toArrayOfMovies() {
                self.movies.append(contentsOf: result)
                completion()
                self.loadThumbnails(forMovies: result)
                
            }
        })
    }
    
    private func loadThumbnails(forMovies movies: [Movie]) {
        for i in 0 ..< self.movies.count {
            self.movies[i].loadBackdrop(completion: {
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [IndexPath(row: i, section: 0)])
                }
            })
        }
        //FOR TESTING PURPOSES ONLY
        DispatchQueue.main.async {
            CoreDataMovieController.deleteAllRecords(fromEndpoint: nil)
            CoreDataMovieController.saveMovies(self.movies, markedAs: MovieSectionEndpoint.favourite)
            for i in CoreDataMovieController.fetchMovies(fromEndpoint: MovieSectionEndpoint.favourite) {
                NSLog("D: \(i.title ?? "wat")")
            }
        }
        //FOR TESTING PURPOSES ONLY
        // using the backdrop images for thumbnails in this case, because the thumbnails are too small for the view
    }
    
    @IBAction func onTapGo(_ sender: UIButton) {
        if let query = self.searchTextField.text {
            self.query = query
            self.movies.removeAll()
            self.fetchData(query: query, completion: {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x:0, y:0), animated: false)
                }
            })
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchMovieCollectionViewCell",
                                                      for: indexPath) as! SearchMovieCollectionViewCell
        cell.backdropImage.image = nil
        let movie = movies[indexPath.row]
        cell.loadData(fromMovie: movie)
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        destination.movie = movie
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 3) {
            self.fetchData(query: self.query, completion: {
                DispatchQueue.main.async(execute: self.collectionView.reloadData)
            })
        }
    }
}
