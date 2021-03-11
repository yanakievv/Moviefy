//
//  CoreDataController.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 10.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataMovieController {
    
    private static let entityName = "MovieModel"
    
    private class func getContext() -> NSManagedObjectContext?
    {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        return (delegate?.persistentContainer.viewContext)
    }
    
    class func saveMovie(_ movie: Movie, markedAs endpoint: MovieSectionEndpoint) {
        guard let context = CoreDataMovieController.getContext() else {
            NSLog("E: CoreData -- getContext() returned nil")
            return
        }
        if let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) {
            let newMovie = NSManagedObject(entity: entity, insertInto: context)
            newMovie.setValue(movie.data.id, forKey: "id")
            newMovie.setValue(movie.data.title, forKey: "title")
            newMovie.setValue(movie.data.backdropPath, forKey: "backdropPath")
            newMovie.setValue(movie.data.posterPath, forKey: "posterPath")
            newMovie.setValue(movie.data.overview, forKey: "overview")
            newMovie.setValue(movie.data.voteAverage, forKey: "voteAverage")
            newMovie.setValue(movie.data.voteCount, forKey: "voteCount")
            newMovie.setValue(movie.data.releaseDate, forKey: "releaseDate")
            newMovie.setValue(endpoint.rawValue, forKey: "markedAs")
            do {
                try context.save()
            }
            catch {
                NSLog("E: CoreData -- saveMovie() \(error)")
            }
        }
        else {
            NSLog("E: CoreData -- saveMovie() entity is nil")
        }
    }
    
    class func saveMovies(_ movies: [Movie], markedAs endpoint: MovieSectionEndpoint) {
        guard let context = CoreDataMovieController.getContext() else {
            NSLog("E: CoreData -- getContext() returned nil")
            return
        }
        if let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) {
            for movie in movies {
                let newMovie = NSManagedObject(entity: entity, insertInto: context)
                newMovie.setValue(movie.data.id, forKey: "id")
                newMovie.setValue(movie.data.title, forKey: "title")
                newMovie.setValue(movie.data.backdropPath, forKey: "backdropPath")
                newMovie.setValue(movie.data.posterPath, forKey: "posterPath")
                newMovie.setValue(movie.data.overview, forKey: "overview")
                newMovie.setValue(movie.data.voteAverage, forKey: "voteAverage")
                newMovie.setValue(movie.data.voteCount, forKey: "voteCount")
                newMovie.setValue(movie.data.releaseDate, forKey: "releaseDate")
                newMovie.setValue(endpoint.rawValue, forKey: "markedAs")
            }
            do {
                try context.save()
            }
            catch {
                NSLog("E: CoreData -- saveMovies() \(error)")
            }
        }
        else {
            NSLog("E: CoreData -- saveMovies() entity is nil")
        }
    }
    
    class func fetchMovies(fromEndpoint endpoint: MovieSectionEndpoint) -> [MovieModel] {
        guard let context = CoreDataMovieController.getContext() else {
            NSLog("E: CoreData -- getContext() returned nil")
            return [MovieModel]()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "markedAs = %@", endpoint.rawValue)
        
        do {
            let result = try context.fetch(request)
            return result as! [MovieModel]
        }
        catch {
            NSLog("E: CoreData -- fetchMovies() \(error)")
        }
        return [MovieModel]()
    }
    
    class func fetchMovie(byId id: Int) -> [MovieModel] {
        guard let context = CoreDataMovieController.getContext() else {
            NSLog("E: CoreData -- getContext() returned nil")
            return [MovieModel]()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = '%@'", "\(id)")
        
        do {
            let result = try context.fetch(request)
            return result as! [MovieModel]
        }
        catch {
            NSLog("E: CoreData -- fetchMovie() \(error)")
        }
        return [MovieModel]()
    }
    
    class func searchMovies(byTitle title: String, markedAs endpoint: MovieSectionEndpoint? = nil) -> [MovieModel] {
        guard let context = CoreDataMovieController.getContext() else {
            NSLog("E: CoreData -- getContext() returned nil")
            return [MovieModel]()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.returnsObjectsAsFaults = false
        
        let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", title) // [c] for case insensitive
        let endpointPredicate: NSPredicate?
        if let section = endpoint?.rawValue {
            endpointPredicate = NSPredicate(format: "markedAs = %@", section)
        }
        else {
            endpointPredicate = NSPredicate(format: "1=1") // my idea of an empty predicate, idk if leaving it just blank would mess up the underlaying SQL queries so I've made it like this
        }
        let finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [titlePredicate, endpointPredicate!])
        request.predicate = finalPredicate
        
        do {
            let result = try context.fetch(request)
            return result as! [MovieModel]
        }
        catch {
            NSLog("E: CoreData -- searchMovies() \(error)")
        }
        return [MovieModel]()
    }
    
    class func deleteAllRecords(fromEndpoint endpoint: MovieSectionEndpoint?) {
        guard let context = CoreDataMovieController.getContext() else {
            NSLog("E: CoreData -- getContext() returned nil")
            return
        }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        let endpointPredicate: NSPredicate?
        if let section = endpoint?.rawValue {
            endpointPredicate = NSPredicate(format: "markedAs = %@", section)
        }
        else {
            endpointPredicate = NSPredicate(format: "1=1") // empty predicate
        }
        deleteFetch.predicate = endpointPredicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            NSLog("E: CoreData -- deleteAllRecords() \(error)")
        }
    }
}

enum MovieSectionEndpoint: String, CaseIterable {
    case favourite = "Favourite"
    case toWatch = "ToWatch"
    case watched = "Watched"
}
