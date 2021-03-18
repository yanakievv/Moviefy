//
//  Util.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    class func getCurrentDateAsString(withFormat format: String) -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: date)
    }
}

extension MoviesResponse {
    func toArrayOfMovies() -> [Movie] {
        var movies = [Movie]()
        self.results.forEach { (movieResponse) in
            movies.append(Movie(withMovieResponse: movieResponse))
        }
        return movies
    }
}

extension UIButton {
    func toggleClickable(clickable: Bool) -> () {
        if (clickable) {
            self.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: UIControl.State.normal)
            self.isEnabled = true
        }
        else {
            self.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: UIControl.State.normal)
            self.isEnabled = false
        }
    }
}

extension UIAlertController {
    func deployCustomIndicator() {
        let constraintHeight = NSLayoutConstraint(
            item: self.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        self.view.addConstraint(constraintHeight)
        
        let constraintWidth = NSLayoutConstraint(
            item: self.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        self.view.addConstraint(constraintWidth)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
    }
}
