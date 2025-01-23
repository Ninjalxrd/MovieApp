//
//  PopularFilms+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Павел on 17.01.2025.
//
//

import Foundation
import CoreData


extension PopularFilms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PopularFilms> {
        return NSFetchRequest<PopularFilms>(entityName: "PopularFilms")
    }

    @NSManaged public var title: String
    @NSManaged public var film_id: Int32
    @NSManaged public var poster: Data?

}

extension PopularFilms : Identifiable {

}
