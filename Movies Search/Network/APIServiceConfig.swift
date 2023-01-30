//
//  APIServiceConfig.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

/*
 This is the place where we configure things like:
 request timeout, baseUrl, apiKey, etc.
 */
final class APIServiceConfig {

    let baseUrl: String
    let timeoutInterval: TimeInterval

    init(baseUrl: String, timeoutInterval: TimeInterval = 60) {
        self.baseUrl = baseUrl
        self.timeoutInterval = timeoutInterval
    }
}
