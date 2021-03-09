//
//  MainTableViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let dataSource = MainTableViewDataSource() 
    
    private func updateNextSet(collectionView: Int){
        self.dataSource.fetchDataIn(section: collectionView)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.dataSource = self.dataSource
        self.dataSource.tableView = self.tableView
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
}

extension MainTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = self.dataSource.getMoviesFromSection(collectionView.tag)?[indexPath.row] else {
            return
        }
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        alert.deployCustomIndicator()
        present(alert, animated: true, completion: nil)
        /*self.dataSource.loadImages(movie: movie, completion: { backdrop, poster in
            destination.prepareData(movie: movie, backdrop: backdrop, poster: poster)
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: {
                    self.navigationController?.pushViewController(destination, animated: true)
                })
            }
        })*/
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 3) {
            updateNextSet(collectionView: collectionView.tag)
            DispatchQueue.main.async(execute: collectionView.reloadData)
        }
    }
}

extension MainTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.getNumberOfMoviesInSection(collectionView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as! MovieCollectionViewCell

        let movie = self.dataSource.getMoviesFromSection(collectionView.tag)?[indexPath.row]
        cell.loadData(from: movie)
        
        return cell
    }
}
