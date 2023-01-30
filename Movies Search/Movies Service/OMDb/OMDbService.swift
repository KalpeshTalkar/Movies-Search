//
//  OMDbService.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

class OMDbService: MoviesService {
    private let baseUrl = "https://www.omdbapi.com/"
    private let apiKey = "b3797056"
    private let apiService: APIService

    private (set) var favorites = [Movie]()
    private (set) var watched = [Movie]()

    init() {
        let config = APIServiceConfig(baseUrl: baseUrl)
        apiService = DefaultAPIService(config: config)
    }

    func searchMovies(title: String, filter: MovieSearchFilter) async throws -> MovieSearchResults {
        var queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "s", value: title)
        ]
        if let page = filter.page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let year = filter.year {
            queryItems.append(URLQueryItem(name: "y", value: year))
        }
        if let type = filter.type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        if let plot = filter.type {
            queryItems.append(URLQueryItem(name: "plot", value: plot))
        }
        let request = APIRequest(method: .get, endpoint: "", queryItems: queryItems)

        let result: APIResult<OMDbSearchResults> = await apiService.execute(request)
        guard let data = result.data else {
            throw result.error ?? GenericError()
        }

        if let error = data.error {
            throw MovieDbError(reason: error)
        }

        let movies = data.results?.map({ MovieItem(omdbMovie: $0) }) ?? []
        return MovieSearchResults(movies: movies, totalResults: 0)
    }

    func getMovieById(id: String, filter: MovieSearchFilter?) async throws -> Movie {
        do {
            return try await getMovie(query: URLQueryItem(name: "i", value: id), filter: filter)
        } catch {
            throw error
        }
    }

    func getMovieByTitle(title: String, filter: MovieSearchFilter?) async throws -> Movie {
        do {
            return try await getMovie(query: URLQueryItem(name: "t", value: title), filter: filter)
        } catch {
            throw error
        }
    }

    private func getMovie(query: URLQueryItem, filter: MovieSearchFilter?) async throws -> Movie {
        var queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            query
        ]
        if let year = filter?.year {
            queryItems.append(URLQueryItem(name: "y", value: year))
        }
        if let type = filter?.type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        if let plot = filter?.type {
            queryItems.append(URLQueryItem(name: "plot", value: plot))
        }
        let request = APIRequest(method: .get, endpoint: "", queryItems: queryItems)

        let result: APIResult<OMDbDTO> = await apiService.execute(request)
        guard let data = result.data else {
            throw result.error ?? GenericError()
        }

        if let error = data.error {
            throw MovieDbError(reason: error)
        }

        return MovieDetails(omdbMovie: data)
    }

    /**
     There is no local storage to persist favorites and watched movies.
     Also, the backend does not support this functionality.
     So this data is persisted here in this service. This can be later refactored to moved
     somewhere else if we are supposed to implement local storage to persist this data.
     If the backend supports storing favorites and watched list, then these functions can remain a part of this service.
     */

    func favorite(movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
        }
    }

    func removeFavorite(movie: Movie) {
        favorites.removeAll(where: { $0.id == movie.id })
    }

    func markWatched(movie: Movie) {
        if !watched.contains(where: { $0.id == movie.id }) {
            watched.append(movie)
        }
    }

    func markedUnWatched(movie: Movie) {
        watched.removeAll(where: { $0.id == movie.id })
    }
}
