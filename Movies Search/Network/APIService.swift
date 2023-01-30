//
//  APIService.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

protocol APIService {
    func execute<T: Decodable>(_ request: APIRequest) async -> APIResult<T>
}
