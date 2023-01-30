//
//  MovieItem.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct MovieItem: Movie {
    var id: String
    var title: String
    var year: String
    var type: MovieType
    var poster: String
    var favorite: Bool
    var watched: Bool
}

extension MovieItem {
    init(omdbMovie: OMDbSearchResultItem) {
        id = omdbMovie.imdbID ?? ""
        title = omdbMovie.title ?? ""
        year = omdbMovie.year ?? ""
        type = MovieType(rawValue: omdbMovie.type ?? "") ?? .movie
        poster = omdbMovie.poster ?? ""
        favorite = false // this property is not locally persisted nor the backend/api supports persisting this value
        watched = false // this property is not locally persisted nor the backend/api supports persisting this value
    }
}
