//
//  ServiceError.swift
//  ProductBrand
//
//  Created by Anand  on 13/02/23.
//

import Foundation

enum ServiceError: Error {
    case requestError
    case responseError
    case parseError(Error)
}
