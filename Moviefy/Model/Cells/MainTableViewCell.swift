//
//  MainTableViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet private var collectionView: UICollectionView!
    private var movies: MovieResponse?
    
    func loadData(from: [MovieResponse?]) {
        if (from.count > self.collectionView.tag) {
            if let data = from[collectionView.tag] {
                movies = data
            }
            else {
                NSLog("W: MainTableViewCell -- loadData from nil movie")
            }
        }
        else {
            NSLog("W: MainTableViewCell -- loadData from nil response")
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forSection section: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = section
        collectionView.reloadData()
    }

}
