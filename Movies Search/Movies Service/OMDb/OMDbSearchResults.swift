//
//  OMDbSearchResults.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct OMDbSearchResults: Decodable {
    let results: [OMDbSearchResultItem]?
    let totalResults: Int?
    let error: String?

    private enum CodingKeys: String, CodingKey {
        case results = "Search"
        case totalResults = "TotalResults"
        case error = "Error"
    }
}
