//
//  Products.swift
//  ProductBrandingNew
//
//  Created by Anand  on 18/02/23.
//

import Foundation

struct Products: Decodable {
        
    var items: [Product]
    
    enum CodingKeys: String, CodingKey {
     case items = "products"
    }
}

struct Product: Decodable {
    var id = UUID()

    var title: String = ""
    var productId: String = ""
    var imageURL: String = ""
    var brand: String = ""
    var price: [Price] = []
    var rating: Double = 0.0

    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case title
        case imageURL,brand, price
        case productId = "id"
        case rating = "ratingCount"
    }
}

struct Price: Decodable {
    
    var value: Double
    var message: String
    var isOfferPrice: Bool
    
    init(value: Double,
         message: String,
         isOfferPrice: Bool) {
        self.value = value
        self.message = message
        self.isOfferPrice = isOfferPrice
    }
}
