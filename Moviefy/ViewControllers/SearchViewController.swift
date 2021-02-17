//
//  SearchViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movies: MovieResponse? = nil
    
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
        cell.loadData(movie: movies?.results[indexPath.row] as! Movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionViewFooter", for: indexPath as IndexPath) as! SearchCollectionReusableView
        footer = footerView
        footer?.toggleViews(visible: (self.movies?.results.count ?? 0) > 0)
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sender = (collectionView.cellForItem(at: indexPath) as! SearchMovieCollectionViewCell).getMovie()
        if (sender != nil) {
            let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
            
            let constraintHeight = NSLayoutConstraint(
                item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
            alert.view.addConstraint(constraintHeight)
            
            let constraintWidth = NSLayoutConstraint(
                item: alert.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
            alert.view.addConstraint(constraintWidth)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            sender?.loadImages(completion: {
                self.dismiss(animated: false, completion: {
                    self.performSegue(withIdentifier: "ShowSearchMovieDetails", sender: sender)
                })
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchData(query: String, page: Int) {
        MovieStore.interface.searchMovie(query: query, page: page, completion: { (response, pages) in
            if let response = response {
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
            if let sender: Movie = sender as? Movie {
                (segue.destination as! DetailsViewController).prepareData(movie: sender)
            }
        }
    }
}
