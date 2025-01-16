//
//  DetailModel.swift
//  MoviesApp
//
//  Created by Павел on 05.01.2025.
//

import UIKit

struct FilmDetail: Codable, Hashable {
    let filmId: Int
    let images: [MovieImage]
    let rating: Double?
    let poster: MoviePoster
    let title: String
    let year: Int
    let runningTime: Int?
    let genres: [FilmGenre]
    let description: String
    let stars: String
    let trailerURL: String
    
    struct MovieImage: Codable, Hashable {
        let image: String
    }
    
    struct MoviePoster: Codable, Hashable {
        let image: String
    }
    
    struct FilmGenre: Codable, Hashable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case filmId = "id"
        case images
        case rating = "imdb_rating"
        case poster
        case title
        case year
        case runningTime = "running_time"
        case genres
        case description = "body_text"
        case stars
        case trailerURL = "trailer"
    }
}
class DetailModel {
    
    private let session: URLSession = URLSession(configuration: .default)
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    func obtainFilmDetails(film_id: Int) async throws -> FilmDetail {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/\(film_id)/") else { throw URLError(.badURL) }
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        let detailFilmResponse = try jsonDecoder.decode(FilmDetail.self, from: responseData.0)
        return detailFilmResponse
    }
    
    func removeTags(filmDescription: String) -> String {
        var results = ""
        var insideTag = false
        for char in filmDescription {
            if char == "<" {
                insideTag = true
            } else if char == ">" {
                insideTag = false
            } else if !insideTag {
                results += String(char)
            }
        }
        return results
    }
    
    func addToWatchlist(filmId: Int) async throws {
        
    }
}
