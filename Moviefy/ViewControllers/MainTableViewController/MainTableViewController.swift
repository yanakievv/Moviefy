//
//  MainTableViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let dataSource = MainTableViewDataSource() 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.dataSource.arrayOfSections.count > collectionView.tag && self.dataSource.arrayOfSections[collectionView.tag] != nil) {
            return self.dataSource.arrayOfSections[collectionView.tag]?.results.count ?? 20
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as! MovieCollectionViewCell
        if (self.dataSource.arrayOfSections.count > collectionView.tag && self.dataSource.arrayOfSections[collectionView.tag] != nil) {
            let movie = self.dataSource.arrayOfSections[collectionView.tag]?.results[indexPath.row] as! MovieResponse
            cell.loadData(from: movie, withThumbnail: self.dataSource.thumbnailsForTitle[movie.title])
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var sender: [String:Any] = [:]
        sender["movie"] = self.dataSource.arrayOfSections[collectionView.tag]?.results[indexPath.row]
        if (sender["movie"] != nil) {
            let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
            alert.deployCustomIndicator()
            present(alert, animated: true, completion: nil)
            self.dataSource.loadImages(movie: sender["movie"] as! MovieResponse, completion: { backdrop, poster in
                sender["backdrop"] = backdrop
                sender["poster"] = poster
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                        self.performSegue(withIdentifier: "ShowMovieDetails", sender: sender)
                    })
                }
            })
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.dataSource = self.dataSource
        self.dataSource.fetchData(completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? MainTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self as UICollectionViewDataSource & UICollectionViewDelegate, forSection: indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowMovieDetails") {
            if let sender: [String:Any] = sender as? [String : Any] {
                (segue.destination as! DetailsViewController).prepareData(movie: sender["movie"] as! MovieResponse?, backdrop: sender["backdrop"] as! UIImage?, poster: sender["poster"] as! UIImage?)
            }
        }
    }
}
