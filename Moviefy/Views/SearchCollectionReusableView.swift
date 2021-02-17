//
//  SearchCollectionReusableView.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 16.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class SearchCollectionReusableView: UICollectionReusableView { 
    @IBOutlet private var currentPageLabel: UILabel!
    @IBOutlet private var previousPageLabel: UILabel!
    @IBOutlet private var nextPageLabel: UILabel!
    
    @IBOutlet private var previousPageButton: UIButton!
    @IBOutlet private var nextPageButton: UIButton!
    
    private var currentPage: Int = 1
    private var pages: Int = 0
    
    func getPages() -> Int {
        return pages
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func search(pages: Int) {
        if (pages == 0) {
            self.toggleViews(visible: false)
            return
        }
        self.pages = pages
        self.currentPage = 1
        previousPageLabel.text = ""
        previousPageLabel.isHidden = true
        previousPageButton.toggleClickable(clickable: false)
        currentPageLabel.text = String(currentPage)
        if (pages > 1) {
            nextPageLabel.isHidden = false
            nextPageLabel.text = String(currentPage + 1)
            nextPageButton.toggleClickable(clickable: true)
        }
        else {
            nextPageLabel.text = ""
            nextPageLabel.isHidden = true
            nextPageButton.toggleClickable(clickable: false)
        }
        
    }
    
    func previousPage() {
        if (currentPage == 1) {
            return
        }
        currentPage -= 1
        if (nextPageLabel.isHidden == true || nextPageButton.isEnabled == false) {
            nextPageLabel.isHidden = false
            nextPageButton.toggleClickable(clickable: true)
        }
        nextPageLabel.text = String(currentPage + 1)
        currentPageLabel.text = String(currentPage)
        if (currentPage == 1) {
            previousPageLabel.isHidden = true
            previousPageLabel.text = ""
            previousPageButton.toggleClickable(clickable: false)
        }
        else {
            previousPageLabel.isHidden = false
            previousPageLabel.text = String(currentPage - 1)
            previousPageButton.toggleClickable(clickable: true)
        }
    }
    
    func nextPage() {
        if (currentPage == pages) {
            return
        }
        currentPage += 1
        if (previousPageLabel.isHidden == true || previousPageButton.isEnabled == false) {
            previousPageLabel.isHidden = false
            previousPageButton.toggleClickable(clickable: true)
        }
        previousPageLabel.text = String(currentPage - 1)
        currentPageLabel.text = String(currentPage)
        if (currentPage == pages) {
            nextPageLabel.isHidden = true
            nextPageLabel.text = ""
            nextPageButton.toggleClickable(clickable: false)
        }
        else {
            nextPageLabel.isHidden = false
            nextPageLabel.text = String(currentPage + 1)
            nextPageButton.toggleClickable(clickable: true)
        }
    }
    
    func toggleViews(visible: Bool) {
        if (visible) {
            currentPageLabel.isHidden = false
            previousPageLabel.isHidden = false
            nextPageLabel.isHidden = false
            
            previousPageButton.isHidden = false
            nextPageButton.isHidden = false
        }
        else {
            currentPageLabel.isHidden = true
            previousPageLabel.isHidden = true
            nextPageLabel.isHidden = true
            
            previousPageButton.isHidden = true
            nextPageButton.isHidden = true
        }
    }
    
}
