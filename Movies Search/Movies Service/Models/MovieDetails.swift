//
//  MovieDetails.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct MovieDetails: Movie {
    var id: String
    var title: String
    var year: String
    var type: MovieType
    var poster: String
    var favorite: Bool
    var watched: Bool
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
    let ratings: [Rating]?
}

extension MovieDetails {
    init(omdbMovie: OMDbDTO) {
        id = omdbMovie.imdbID ?? ""
        title = omdbMovie.title ?? ""
        year = omdbMovie.year ?? ""
        type = MovieType(rawValue: omdbMovie.type ?? "") ?? .movie
        poster = omdbMovie.poster ?? ""
        rated = omdbMovie.rated
        released = omdbMovie.released
        runtime = omdbMovie.runtime
        genre = omdbMovie.genre
        writer = omdbMovie.writer
        actors = omdbMovie.actors
        plot = omdbMovie.plot
        language = omdbMovie.language
        country = omdbMovie.country
        awards = omdbMovie.awards
        metascore = omdbMovie.metascore
        imdbRating = omdbMovie.imdbRating
        totalSeasons = omdbMovie.totalSeasons
        boxOffice = omdbMovie.boxOffice
        ratings = omdbMovie.ratings?.map({
            Rating(source: $0.source, value: $0.value)
        })
        favorite = false // this property is not locally persisted nor the backend/api supports persisting this value
        watched = false // this property is not locally persisted nor the backend/api supports persisting this value
    }
}
