//
//  OMDbDTO.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct OMDbDTO: Decodable {
    let imdbID: String?
    let title: String?
    let year: String?
    let type: String?
    let poster: String?
    let rated: String?
    let released: String?
    let runtime: String?
    let genre: String?
    let writer: String?
    let actors: String?
    let plot: String?
    let language: String?
    let country: String?
    let awards: String?
    let metascore: String?
    let imdbRating: String?
    let totalSeasons: String?
    let boxOffice: String?
    let ratings: [OMDbRating]?
    let error: String?

    private enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case metascore = "Metascore"
        case imdbRating
        case totalSeasons = "TotalSeasons"
        case boxOffice = "BoxOffice"
        case ratings = "Ratings"
        case error = "Error"
    }
}
