//
//  SearchViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // TODO: rework in a way to remove paging and make a single page with all the content being loaded on the go
    
    var movies: MoviesResponse? = nil
    var thumbnails: [String : UIImage] = [:]
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    var footer: SearchCollectionReusableView?
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionViewFooter", for: indexPath as IndexPath) as! SearchCollectionReusableView
        footer = footerView
        footer?.toggleViews(visible: (self.movies?.results.count ?? 0) > 0)
        return footerView
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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchData(query: String, page: Int) {
        MovieStore().searchMovie(query: query, page: page, completion: { (response, pages) in
            if let response = response {
                self.loadThumbnails(forMovieResponse: response)
                self.movies = response
                DispatchQueue.main.async {
                    if (pages == 0) {
                        self.footer?.toggleViews(visible: false)
                    }
                    else if (pages > 0 && page == 1) {
                        self.footer?.toggleViews(visible: true)
                        self.footer?.search(pages: pages)
                    }
                    self.collectionView.reloadData()
                }
            }
            })
    }
    
    func loadThumbnails(forMovieResponse: MoviesResponse!) {
        for i in forMovieResponse.results as! [MovieResponse] {
            self.loadThumbnail(movie: i)
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
    
    @IBAction func onTapGo(_ sender: UIButton) {
        if let query = self.searchTextField.text {
            self.fetchData(query: query, page: 1)
        }
    }
    @IBAction func onTapPrevious(_ sender: UIButton) {
        if let query = self.searchTextField.text {
            self.footer?.previousPage()
            self.fetchData(query: query, page: footer!.getCurrentPage())
        }
    }
    @IBAction func onTapNext(_ sender: UIButton) {
        if let query = self.searchTextField.text {
            self.footer?.nextPage()
            self.fetchData(query: query, page: footer!.getCurrentPage())
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
