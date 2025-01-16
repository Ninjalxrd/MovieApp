//
//  Film+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Павел on 12.01.2025.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var film_id: Int32
    @NSManaged public var poster: Data?
    @NSManaged public var title: String?
    @NSManaged public var genre: String?
    @NSManaged public var year: Int16
    @NSManaged public var duration: Int16
    @NSManaged public var rating: Double
    @NSManaged public var addingTime: Date
    @NSManaged public var citySlug: String?

    


}

extension Film : Identifiable {

}
