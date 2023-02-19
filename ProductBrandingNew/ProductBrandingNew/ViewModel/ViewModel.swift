//
//  ViewModel.swift
//  ProductBrand
//
//  Created by Anand  on 13/02/23.
//

import Combine

protocol ViewModel: ObservableObject {
    associatedtype Input: Equatable
    
    var cancellables: [AnyCancellable] { get }
    func apply(input: Input)
}
