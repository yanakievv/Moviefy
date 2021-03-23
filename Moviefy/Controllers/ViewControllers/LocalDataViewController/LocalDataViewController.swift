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
    
    let collectionViewDataSource = LocalDataCollectionViewDataSource()
    let transparentView = UIView()
    
    var category = "All"
    let categoriesTableView = UITableView()
    let categoriesTableViewDelegate = PopupMenuTableViewDelegate()
    let categoriesTableViewDataSource = PopupMenuTableViewDataSource()
    
    var popupShown = false
    
    private var tableViewFrame: CGRect {
        return CGRect(x: self.view.frame.origin.x + self.view.frame.width - 200, y: self.tableViewHeight, width: 200, height: self.getHeightBySize(self.view.frame.size))
        
    }
    
    private var tableViewHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.size.height ?? CGFloat(60))
    }
    
    private func getHeightBySize(_ size: CGSize) -> CGFloat {
        if (size.height < size.width) {
            return UIScreen.main.bounds.height / 2.3
        }
        else {
            return UIScreen.main.bounds.height / 5.2
        }
    }
    
    private func addTransparentView() {
        self.view.addSubview(self.transparentView)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: transparentView, attribute: $0, relatedBy: .equal, toItem: view.superview, attribute: $0, multiplier: 1, constant: 0)
        })

        
        self.categoriesTableView.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.width - 200, y: self.tableViewHeight, width: 200, height: 0)
        self.categoriesTableView.isScrollEnabled = false
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
            self.categoriesTableView.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.width - 200, y: self.tableViewHeight, width: 200, height: 0)
            self.popupShown = false
        }, completion: nil)
    }
    
    @objc func changeCategory(_ notification: NSNotification) {
        if let target = notification.userInfo?["indexPath"] as? IndexPath {
            self.collectionViewDataSource.fetchData(fromSection: (target.row == 0) ? nil : MovieSectionEndpoint.allCases[target.row - 1])
            self.collectionView.reloadData()
            self.category = (target.row == 0) ? "All" : MovieSectionEndpoint.allCases[target.row - 1].rawValue
            self.categoryLabel.text = self.category
            self.removeTransparentView()
        }
    }
    
    @objc func refreshCollectionView() {
        self.collectionViewDataSource.fetchData(fromSection: self.collectionViewDataSource.endpoint)
        self.collectionView.reloadData()
    }
    
    private func setupTableView() {
        self.categoriesTableView.dataSource = self.categoriesTableViewDataSource
        self.categoriesTableView.delegate = self.categoriesTableViewDelegate
        self.categoriesTableView.register(PopupMenuTableViewCell.self, forCellReuseIdentifier: "PopupMenuTableViewCell")
        self.categoriesTableView.alwaysBounceVertical = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionViewDataSource.fetchData(fromSection: nil)
        self.category = "All"
        self.collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.categoryLabel.text = self.category
        NotificationCenter.default.addObserver(self, selector: #selector(changeCategory), name: NSNotification.Name(rawValue: "ChangeCategory"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCollectionView), name: NSNotification.Name(rawValue: "RefreshCollectionView"), object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.removeTransparentView()
    }
    
    @IBAction func onTapCategoriesButton(_ sender: Any) {
        if (self.popupShown) {
            self.removeTransparentView()
        }
        else {
            self.addTransparentView()
        }
    }

}

extension LocalDataViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieModel = self.collectionViewDataSource.getMovie(atIndex: indexPath.row) else {
            return
        }
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        destination.movie = Movie(withMovieModel: movieModel)
        self.navigationController?.pushViewController(destination, animated: true)
    }
}


