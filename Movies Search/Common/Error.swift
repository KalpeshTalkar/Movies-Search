//
//  Error.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

struct MovieDbError: LocalizedError {
    let reason: String

    var errorDescription: String? {
        return reason
    }
}

struct GenericError: LocalizedError {
    var errorDescription: String? {
        return "Some unknown error occurred. Please try again later."
    }
}

struct InvalidURLError: LocalizedError {
    var errorDescription: String? {
        return "Failed to build URLRequest make sure if your url is valid."
    }
}
