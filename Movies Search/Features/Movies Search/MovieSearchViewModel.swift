//
//  MovieSearchViewModel.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation
import Combine

@MainActor
class MovieSearchViewModel {
    private let moviesService: MoviesService

    private var searchTitle: String? = nil
    private var currentPage: Int = 1
    private var isLoading = false
    private var shouldLoadMore: Bool = false
    private var favorites = [Movie]()
    private var watched = [Movie]()

    let loadingSubject = PassthroughSubject<Bool, Never>()
    let errorSubject = PassthroughSubject<Error, Never>()
    let moviesSubject = CurrentValueSubject<[Movie], Never>([])

    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }

    func searchMovie(title:  String) {
        let query = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty, !isLoading else {
            return
        }
        searchTitle = query
        moviesSubject.value.removeAll()
        fetchMovies(title: title, loadMore: false)
    }

    func loadMore() {
        guard let title = searchTitle, !isLoading else { return }
        currentPage+=1
        fetchMovies(title: title, loadMore: true)
    }

    private func fetchMovies(title: String, loadMore: Bool) {
        Task {
            isLoading = true
            loadingSubject.send(true)
            do {
                let filter = MovieSearchFilter(year: nil, page: currentPage, type: nil, plot: nil)
                let result = try await moviesService.searchMovies(title: title, filter: filter)

                // filter out watched movies
                var movies = result.movies.filter({ movie in !moviesService.watched.contains(where: { $0.id != movie.id }) })
                // mark favorite to favorite movies
                for i in 0..<movies.count {
                    let movie = movies[i]
                    if moviesService.favorites.contains(where: { $0.id != movie.id }) {
                        movies[i].favorite = true
                    }
                }
                moviesSubject.value.append(contentsOf: movies)
                shouldLoadMore = result.totalResults > result.movies.count
            } catch {
                errorSubject.send(error)
            }
            isLoading = false
            loadingSubject.send(false)
        }
    }

    func favorite(movie: Movie) {
        if let index = moviesSubject.value.firstIndex(where: { $0.id == movie.id }) {
            moviesSubject.value[index].favorite = true
            moviesService.favorite(movie: movie)
        }
    }

    func removeFavorite(movie: Movie) {
        if let index = moviesSubject.value.firstIndex(where: { $0.id == movie.id }) {
            moviesSubject.value[index].favorite = false
            moviesService.removeFavorite(movie: movie)
        }
    }

    func markWatched(movie: Movie) {
        if let index = moviesSubject.value.firstIndex(where: { $0.id == movie.id }) {
            moviesSubject.value[index].watched = true
            moviesService.markWatched(movie: movie)
        }
    }

    func markedUnWatched(movie: Movie) {
        if let index = moviesSubject.value.firstIndex(where: { $0.id == movie.id }) {
            moviesSubject.value[index].watched = false
            moviesService.markedUnWatched(movie: movie)
        }
    }
}
