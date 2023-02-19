//
//  Request.swift
//  ProductBrand
//
//  Created by Anand  on 13/02/23.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

