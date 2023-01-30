//
//  MovieSearchResults.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct MovieSearchResults {
    let movies: [Movie]
    let totalResults: Int
}

extension MovieSearchResults {
    init(omdbSearchResults: OMDbSearchResults) {
        movies = omdbSearchResults.results?.compactMap({
            MovieItem(omdbMovie: $0)
        }) ?? []
        totalResults = omdbSearchResults.totalResults ?? 0
    }
}
