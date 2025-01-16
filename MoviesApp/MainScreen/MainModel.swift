//
//  MainModel.swift
//  MoviesApp
//
//  Created by Павел on 29.12.2024.
//

import Foundation
import UIKit

struct FilmResponse: Codable, Hashable {
    let results: [FilmShort]
}

struct FilmShort: Codable, Hashable {
    
    let film_id: Int
    let title: String
    let poster: MoviePoster
    
    enum CodingKeys: String, CodingKey {
        case film_id = "id"
        case poster
        case title
    }
}

struct MoviePoster: Codable, Hashable {
    let image: String
}

struct City: Codable, Hashable {
    let name: String
    let slug: String
}

class MainModel {
    
    private let session: URLSession = URLSession(configuration: .default)
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    func obtainMostPopularFilms() async throws -> [FilmShort] {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/") else { return []}
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        let filmResponse = try jsonDecoder.decode(FilmResponse.self, from: responseData.0)
        return filmResponse.results
    }
    
    func obtainFilmsByCity(citySlug: String, page: Int) async throws -> [FilmShort] {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/?location=\(citySlug)&page=\(page)") else { return []}
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        let filmResponse = try jsonDecoder.decode(FilmResponse.self, from: responseData.0)
        return filmResponse.results
    }

    func obtainCity() async throws -> [City] {
        guard let url = URL(string: "https://kudago.com/public-api/v1.2/locations/?lang=ru") else { return []}
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        let cityResponse = try jsonDecoder.decode([City].self, from: responseData.0)
        return cityResponse
    }
    
}
