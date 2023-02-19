//
//  Service.swift
//  ProductBrand
//
//  Created by Anand  on 14/02/23.
//

import Foundation
import Combine

protocol Service {
    var baseURLString: String { get }
    var cancellables: [AnyCancellable] { get }

    func response<T>(from request: T) -> AnyPublisher<T.Response, ServiceError> where T: APIRequest
}

extension Service {
    
    func response<T>(from request: T) -> AnyPublisher<T.Response, ServiceError> where T: APIRequest {
        
        guard let relativeToURL = URL(string: baseURLString),
              let pathURL = URL(string: request.path, relativeTo: relativeToURL) else {
            return Fail(error: ServiceError.requestError)
                .eraseToAnyPublisher()
        }
        
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = request.queryItems
        
        guard let url = urlComponents?.url else {
            return Fail(error: ServiceError.requestError)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, urlResponse in data }
            .mapError { _ in ServiceError.responseError }
            .decode(type: T.Response.self, decoder: decoder)
            .mapError(ServiceError.parseError)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
