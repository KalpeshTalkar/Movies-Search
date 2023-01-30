//
//  DefaultAPIService.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 25/01/2023.
//

import Foundation

class DefaultAPIService: APIService {

    private let config: APIServiceConfig

    init(config: APIServiceConfig) {
        self.config = config
    }

    func execute<T: Decodable>(_ request: APIRequest) async -> APIResult<T> {
        guard let urlRequest = buildRequest(request) else {
            return APIResult(data: nil, error: InvalidURLError())
        }

        do {
            let response = try await URLSession.shared.data(for: urlRequest)
            let data = try response.0.decode(to: T.self)
            return APIResult<T>(data: data, error: nil)
        } catch {
            return APIResult(data: nil, error: error)
        }
    }

    private func buildRequest(_ apiRequest: APIRequest) -> URLRequest? {
        guard let url = URL(string: "\(config.baseUrl)/\(apiRequest.endpoint)") else {
            return nil
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        if !apiRequest.queryItems.isEmpty {
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = apiRequest.queryItems
            request.url = components?.url
        }

        request.httpMethod = apiRequest.method.rawValue

        apiRequest.headers.forEach({ key, value in
            request.setValue(value, forHTTPHeaderField: key)
        })

        request.httpBody  = apiRequest.body

        return request
    }
}
