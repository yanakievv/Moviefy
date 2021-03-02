//
//  SearchViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //private var pages: Int = 1
    private var query: String = ""
    
    private var movies: MoviesResponse? = nil
    private var thumbnails: [String : UIImage] = [:]
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchMovieCollectionViewCell",
                                                      for: indexPath) as! SearchMovieCollectionViewCell
        let movie = movies?.results[indexPath.row] as! MovieResponse
        cell.loadData(movie: movie, withImage: thumbnails[movie.title])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var sender: [String:Any] = [:]
        sender["movie"] = movies?.results[indexPath.row]
        if (sender["movie"] != nil) {
            let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
            alert.deployCustomIndicator()
            present(alert, animated: true, completion: nil)
            self.loadImages(movie: sender["movie"] as! MovieResponse, completion: { backdrop, poster in
                sender["backdrop"] = backdrop
                sender["poster"] = poster
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                        self.performSegue(withIdentifier: "ShowSearchMovieDetails", sender: sender)
                    })
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 3) {
            self.fetchData(query: self.query, completion: {
                DispatchQueue.main.async(execute: self.collectionView.reloadData)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchData(query: String, completion: @escaping () -> ()) {
        MovieStore().searchMovie(query: query, page: (((self.movies?.results.count ?? 0) / 20) + 1), completion: { (response, pages) in
            if let response = response {
                self.loadThumbnails(forMovies: response.results)
                if (self.movies != nil) {
                    for movie in response.results {
                        self.movies?.results.add(movie)
                    }
                }
                else {
                    self.movies = response
                }
                completion()
            }
        })
    }
    
    private func loadThumbnails(forMovies: NSMutableArray) {
        for i in forMovies {
            self.loadThumbnail(movie: i as! MovieResponse)
        }
    }
    
    private func loadThumbnail(movie: MovieResponse) {
        MovieStore().getImage(path: movie.backdropPath ?? "", size: MovieImageSize.medium, completion: {img in
            if (movie.backdropPath == nil || movie.backdropPath == "") {
                self.thumbnails[movie.title] = UIImage(named: "no-image.png")
            }
            else if let img = img {
                self.thumbnails[movie.title] = UIImage(data: img)
            }
        })
    }
    
    private func loadImages(movie: MovieResponse, completion: @escaping (UIImage?, UIImage?) -> ()) {
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
    
    @IBAction func onTapGo(_ sender: UIButton) {
        if let query = self.searchTextField.text {
            self.query = query
            self.movies = nil
            self.thumbnails = [:]
            self.fetchData(query: query, completion: {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowSearchMovieDetails") {
            if let sender: [String : Any] = sender as? [String : Any] {
                (segue.destination as! DetailsViewController).prepareData(movie: sender["movie"] as! MovieResponse?, backdrop: sender["backdrop"] as! UIImage?, poster: sender["poster"] as! UIImage?)
            }
        }
    }
}
