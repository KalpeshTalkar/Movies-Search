//
//  Movie.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

enum MovieType: String, Decodable {
    case movie, series, episode
}

protocol Movie {
    var id: String { get set }
    var title: String { get set }
    var year: String { get set }
    var type: MovieType { get set }
    var poster: String { get set }
    var favorite: Bool { get set } // this property is not locally persisted nor the backend/api supports persisting this value
    var watched: Bool { get set } // this property is not locally persisted nor the backend/api supports persisting this value
}
