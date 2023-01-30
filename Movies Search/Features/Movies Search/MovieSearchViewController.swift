//
//  MovieSearchViewController.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import UIKit
import Combine

class MovieSearchViewController: UIViewController {

    @IBOutlet private var loadingViewBottom: NSLayoutConstraint!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: MovieSearchViewModel!

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setSubscribers()
    }

    deinit {
        subscriptions.forEach({ $0.cancel() })
        subscriptions.removeAll()
    }

    private func setupUI() {
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "Search movies"
        searchBar.becomeFirstResponder()

        tableView.rowHeight = 120
        tableView.register(UINib(nibName: "MovieSearchItemCell", bundle: nil), forCellReuseIdentifier: "MovieSearchItemCell")
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setSubscribers() {
        viewModel.moviesSubject.sink { [weak self] movies in
            guard let self else { return }
            self.tableView.reloadData()
        }.store(in: &subscriptions)

        viewModel.errorSubject.sink { [weak self] error in
            guard let self else { return }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true)
        }.store(in: &subscriptions)

        viewModel.loadingSubject.sink { [weak self] loading in
            guard let self else { return }
            self.loadingView.isHidden = !loading
            var loaderBottom: CGFloat = -self.loadingView.bounds.height
            self.activityIndicator.stopAnimating()
            if loading {
                self.activityIndicator.startAnimating()
                if self.viewModel.moviesSubject.value.isEmpty {
                    loaderBottom = self.tableView.bounds.height / 2
                } else {
                    loaderBottom = 0
                }
            }
            self.loadingViewBottom.constant = loaderBottom
            self.view.layoutIfNeeded()
        }.store(in: &subscriptions)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let text = searchBar.text else {
            return
        }
        viewModel.searchMovie(title: text)
    }
}

extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesSubject.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.moviesSubject.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchItemCell", for: indexPath) as! MovieSearchItemCell
        cell.configure(movie)
        cell.favTapped = { [weak self] in
            guard let self else { return }
            if movie.favorite {
                self.viewModel.removeFavorite(movie: movie)
            } else {
                self.viewModel.favorite(movie: movie)
            }
        }
        return cell
    }
}

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovieSearchViewController: UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.moviesSubject.value.count - 1
        if indexPath.row == lastElement {
            viewModel.loadMore()
        }
    }
}
