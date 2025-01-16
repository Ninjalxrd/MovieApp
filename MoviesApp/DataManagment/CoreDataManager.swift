//
//  CoreDataManager.swift
//  MoviesApp
//
//  Created by Павел on 12.01.2025.
//

import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createFetchResultsController() -> NSFetchedResultsController<Film> {
        let filmFetchRequest = Film.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "addingTime", ascending: false)
        filmFetchRequest.sortDescriptors = [sortDescriptor]
        
        let resultController = NSFetchedResultsController(fetchRequest: filmFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return resultController
    }
    
    func obtainSavedFilms(for citySlug: String) -> [FilmShort] {
        let filmRequest = Film.fetchRequest()
        let predicate = NSPredicate(format: "citySlug == %@", citySlug)
        filmRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "film_id", ascending: false)
        filmRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let filmEntities = try viewContext.fetch(filmRequest)
            let films: [FilmShort] = filmEntities.map {
                filmEntity in
                FilmShort(film_id: Int(filmEntity.film_id),
                          title: filmEntity.title ?? "",
                          poster: MoviePoster(image: filmEntity.poster?.base64EncodedString() ?? ""))
            }
            return films
        } catch {
            print("error with obtaining data \(error)")
            return []
        }
    }
    
    func saveMainScreenFilms(film: FilmShort, for citySlug: String) {
        let backgroundContext = backgroundContext
        let group = DispatchGroup()
        backgroundContext.perform {
            let filmEntity = Film(context: backgroundContext)
            filmEntity.title = film.title
            filmEntity.film_id = Int32(film.film_id)
            filmEntity.citySlug = citySlug
            
            group.enter()
            Task {
                let image = try await ImageService.downloadImage(by: film.poster.image)
                let imageData = image?.pngData()
                filmEntity.poster = imageData
                group.leave()
            }
            group.notify(queue: .main) {
                do {
                    try backgroundContext.save()
                } catch {
                    print("error to saving to background context \(error)")
                }
            }
        }
    }
    
    func saveFilm(film: FilmDetail) {
        let backgroundContext = backgroundContext
        let group = DispatchGroup()
        backgroundContext.perform { [weak viewContext] in
            guard let viewContext else { return }
            viewContext.automaticallyMergesChangesFromParent = true
            let filmEntity = Film(context: backgroundContext)
            filmEntity.film_id = Int32(film.filmId)
            filmEntity.title = film.title
            filmEntity.addingTime = Date()
            filmEntity.duration = Int16(film.runningTime ?? 0)
            filmEntity.genre = film.genres.first?.name ?? ""
            filmEntity.rating = film.rating ?? 0.0
            filmEntity.year = Int16(film.year)
            
            group.enter()
            
            Task {
                let image = try await ImageService.downloadImage(by: film.poster.image)
                let imageData = image?.pngData()
                filmEntity.poster = imageData
                group.leave()
            }
            
            group.notify(queue: .main) {
                do {
                    try backgroundContext.save()
                } catch {
                    print("error to saving to background context \(error)")
                }
            }
        }
    }
        
    func deleteFilm(filmId: Int) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Film.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "film_id == %d", Int32(filmId))
            
            do {
                let film = try backgroundContext.fetch(fetchRequest)
                
                if let existingFilm = film.first {
                    backgroundContext.delete(existingFilm)
                }
                do {
                    try backgroundContext.save()
                } catch {
                    print("error saving background context after deleting film \(error)")
                }
            } catch {
                print("error fetching delete film \(error)")
            }
        }
    }
}
