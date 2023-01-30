//
//  OMDbRating.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

struct OMDbRating: Decodable {
    let source: String
    let value: String

    private enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
