//
//  LocalDataViewController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 15.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class LocalDataViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var categoriesButton: UIBarButtonItem!
    @IBOutlet var categoryLabel: UILabel!
    
    let dataSource = LocalDataCollectionViewDataSource()
    let transparentView = UIView()
    
    var category = "Favourite"
    let categoriesTableView = SelfSizingTableView()
    let categoriesTableViewDelegate = PopupMenuTableViewDelegate()
    let categoriesTableViewDataSource = PopupMenuTableViewDataSource()
    
    var popupShown = false
    
    private var tableViewFrame: CGRect {
        return CGRect(x: self.view.frame.origin.x + self.view.frame.width - 200, y: self.view.frame.origin.y, width: 200, height: 220)
    }
    
    private func addTransparentView() {
        if (self.popupShown) {
            self.removeTransparentView()
            return
        }
        self.view.addSubview(self.transparentView)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: transparentView, attribute: $0, relatedBy: .equal, toItem: view.superview, attribute: $0, multiplier: 1, constant: 0)
        })


        self.categoriesTableView.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.width - 200, y: self.view.frame.origin.y, width: 200, height: 0)
        self.view.addSubview(self.categoriesTableView)
        self.categoriesTableView.layer.cornerRadius = 5
        
        self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        self.transparentView.addGestureRecognizer(tapGesture)
        self.transparentView.alpha = 0.0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.categoriesTableView.frame = self.tableViewFrame
            self.popupShown = true
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.0
            self.categoriesTableView.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.width - 200, y: self.view.frame.origin.y, width: 200, height: 0)
            self.popupShown = false
        }, completion: nil)
    }
    
    @objc func changeCategory(_ notification: NSNotification) {
        if let target = notification.userInfo?["indexPath"] as? IndexPath {
            self.dataSource.fetchData(fromSection: MovieSectionEndpoint.allCases[target.row])
            self.collectionView.reloadData()
            self.category = MovieSectionEndpoint.allCases[target.row].rawValue
            self.categoryLabel.text = self.category
            self.removeTransparentView()
        }
    }
    
    private func setupTableView() {
        self.categoriesTableView.dataSource = self.categoriesTableViewDataSource
        self.categoriesTableView.delegate = self.categoriesTableViewDelegate
        self.categoriesTableView.register(PopupMenuTableViewCell.self, forCellReuseIdentifier: "PopupMenuTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.dataSource = self.dataSource
        self.dataSource.fetchData(fromSection: nil)
        self.collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.categoryLabel.text = self.category
        NotificationCenter.default.addObserver(self, selector: #selector(changeCategory), name: NSNotification.Name(rawValue: "ChangeCategory"), object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.categoriesTableView.frame = CGRect(x: self.view.frame.origin.x + size.width - 200, y: self.view.frame.origin.y, width: 200, height: 220)
    }
    
    @IBAction func onTapCategoriesButton(_ sender: Any) {
        self.addTransparentView()
    }
}

extension LocalDataViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*guard let movie = self.dataSource.getMoviesFromSection(collectionView.tag)?[indexPath.row] else {
            return
        }
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        destination.movie = movie
        self.navigationController?.pushViewController(destination, animated: true)*/
    }
    
}

