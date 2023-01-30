//
//  APIRequest.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

/// Type representing HTTP request methods.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct APIRequest {
    var method: HTTPMethod
    var endpoint: String
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: Data?

    init(method: HTTPMethod, endpoint: String,
         queryItems: [URLQueryItem] = [],
         headers: [String: String] = ["Content-Type": "application/json"],
         body: Data? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}
