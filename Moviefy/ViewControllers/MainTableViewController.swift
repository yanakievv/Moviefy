//
//  MainTableViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var popular: MovieResponse?
    var trending: MovieResponse?
    var topRated: MovieResponse?
    var upcoming: MovieResponse?
    
    var arrayOfSections = [MovieResponse?]()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.arrayOfSections.count > collectionView.tag && self.arrayOfSections[collectionView.tag] != nil) {
            return self.arrayOfSections[collectionView.tag]?.results.count ?? 20
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as! MovieCollectionViewCell

        if (self.arrayOfSections.count > collectionView.tag && self.arrayOfSections[collectionView.tag] != nil) {
            cell.loadData(from: self.arrayOfSections[collectionView.tag]?.results[indexPath.row] as? Movie)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sender = (collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell).getMovie()
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
                    self.performSegue(withIdentifier: "ShowMovieDetails", sender: sender)
                    })
            })
        }
    }
    
    func fetchData() {
        MovieStore.interface.getMovies(from: MovieListEndpoint.popular, completion: { response in
            if let response = response {
                self.popular = response
                self.arrayOfSections.append(self.popular)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        MovieStore.interface.getMovies(from: MovieListEndpoint.nowPlaying, completion: { response in
            if let response = response {
                self.trending = response
                self.arrayOfSections.append(self.trending)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        MovieStore.interface.getMovies(from: MovieListEndpoint.topRated, completion: { response in
            if let response = response {
                self.topRated = response
                self.arrayOfSections.append(self.topRated)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        MovieStore.interface.getMovies(from: MovieListEndpoint.upcoming, completion: { response in
            if let response = response {
                self.upcoming = response
                self.arrayOfSections.append(self.upcoming)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 4: return 0
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? MainTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self as UICollectionViewDataSource & UICollectionViewDelegate, forSection: indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch (section) {
        case 0: return "Popular"
        case 1: return "Trending"
        case 2: return "Top Rated"
        case 3: return "Upcoming"
        default: return "Search"
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.loadData(from: arrayOfSections)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowMovieDetails") {
            if let sender: Movie = sender as? Movie {
                (segue.destination as! DetailsViewController).prepareData(movie: sender)
            }
        }
    }
}
