//
//  OMDbSearchResultItem.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct OMDbSearchResultItem: Decodable {
    let imdbID: String?
    let title: String?
    let year: String?
    let type: String?
    let poster: String?

    private enum CodingKeys: String, CodingKey {
        case imdbID = ""
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
