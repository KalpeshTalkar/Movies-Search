//
//  Application.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import Foundation

class Application {

    static let shared = Application()

    let moviesService: MoviesService

    private init() {
        moviesService = OMDbService()
    }
}
