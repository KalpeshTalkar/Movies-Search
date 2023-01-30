//
//  APIResult.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

struct APIResult<T: Decodable> {
    let data: T?
    let error: Error?
}
