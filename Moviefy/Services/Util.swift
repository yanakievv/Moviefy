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

public class AtomicInteger {
    
    private let lock = DispatchSemaphore(value: 1)
    private var value = 0
    
    public func get() -> Int {
        
        lock.wait()
        defer { lock.signal() }
        return value
    }
    
    public func set(_ newValue: Int) {
        
        lock.wait()
        defer { lock.signal() }
        value = newValue
    }
    
    public func increment() {
        lock.wait()
        defer { lock.signal() }
        value += 1
    }
    
    public func incrementAndGet() -> Int {
        
        lock.wait()
        defer { lock.signal() }
        value += 1
        return value
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

extension UIView {
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            NSLog("No action")
        }
    }
    
}
