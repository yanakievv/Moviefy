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
    
    private var movies = [MovieResponse]()
    private var thumbnails: [String : UIImage] = [:]
    
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
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                self.movies.append(contentsOf: response.results)
                completion()
            }
        })
    }
    
    private func loadThumbnails(forMovies movies: [MovieResponse]) {
        movies.forEach({ self.loadThumbnail(movie: $0) })
    }
    
    private func loadThumbnail(movie: MovieResponse) {
        if let backdropPath = movie.backdropPath {
            MovieStore().getImage(path: backdropPath, size: MovieImageSize.medium, completion: {img in
                if let img = img {
                    self.thumbnails[movie.title] = UIImage(data: img)
                }
                else {
                    self.thumbnails[movie.title] = UIImage(named: "no-image.png")
                }
            })
        }
        else {
            self.thumbnails[movie.title] = UIImage(named: "no-image.png")
        }
    }
    
    private func loadImages(movie: MovieResponse, completion: @escaping (UIImage?, UIImage?) -> ()) {
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
    }
    
    @IBAction func onTapGo(_ sender: UIButton) {
        if let query = self.searchTextField.text {
            self.query = query
            self.movies.removeAll()
            self.thumbnails = [:]
            self.fetchData(query: query, completion: {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
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
        cell.loadData(fromMovie: movie, withImage: thumbnails[movie.title])
        return cell
    }
}
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        alert.deployCustomIndicator()
        present(alert, animated: true, completion: nil)
        self.loadImages(movie: movie, completion: { backdrop, poster in
            destination.prepareData(movie: movie, backdrop: backdrop, poster: poster)
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: {
                    self.navigationController?.pushViewController(destination, animated: true)
                })
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 3) {
            self.fetchData(query: self.query, completion: {
                DispatchQueue.main.async(execute: self.collectionView.reloadData)
            })
        }
    }
}
