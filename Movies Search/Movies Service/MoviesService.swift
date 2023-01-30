//
//  MoviesService.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

protocol MoviesService {
    var favorites: [Movie] { get }
    var watched: [Movie] { get }
    
    func searchMovies(title: String, filter: MovieSearchFilter) async throws -> MovieSearchResults
    func getMovieById(id: String, filter: MovieSearchFilter?) async throws -> Movie
    func getMovieByTitle(title: String, filter: MovieSearchFilter?) async throws -> Movie

    func favorite(movie: Movie)
    func removeFavorite(movie: Movie)
    func markWatched(movie: Movie)
    func markedUnWatched(movie: Movie)
}
