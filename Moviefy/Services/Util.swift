//
//  Util.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 9.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation

class Util {
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yiyy-mm-dd"
        return dateFormatter
    }()
}

extension String{
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
}

extension NSDictionary {
    func toMovie() -> Movie {
        return Movie(id: self.value(forKeyPath: MovieKey.id.rawValue) as! Int, title: self.value(forKeyPath: MovieKey.title.rawValue) as! String, backdropPath: self.value(forKeyPath: MovieKey.backdropPath.rawValue) as? String, posterPath: self.value(forKeyPath: MovieKey.posterPath.rawValue) as? String, overview: self.value(forKeyPath: MovieKey.overview.rawValue) as! String, voteAverage: self.value(forKeyPath: MovieKey.voteAverage.rawValue) as! Double, voteCount: self.value(forKeyPath: MovieKey.voteCount.rawValue) as! Int)
    }
}
