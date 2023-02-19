//
//  RemoteImage.swift
//  ProductBrand
//
//  Created by Anand  on 14/02/23.
//

import SwiftUI
import Combine

final class RemoteImage : ObservableObject {

    enum LoadingState {

        case initial

        case inProgress

        case success(_ image: Image)

        case failure
    }

    @Published var loadingState: LoadingState = .initial
    
    private let cache = URLCache.shared

    let url: URL


    init(url: URL) {
        self.url = url
    }

    func load() {
        loadingState = .inProgress
        
        if let response = cache.cachedResponse(for: URLRequest(url: url))  {
            guard let value = UIImage(data: response.data) else {
                loadingState = .failure
                return
            }
            
            loadingState = .success(Image(uiImage: value))
        }
        else {
            cancellable = URLSession(configuration: .default)
                .dataTaskPublisher(for: url)
                .map {
                    guard let value = UIImage(data: $0.data) else {
                        return .failure
                    }
                    self.cache.storeCachedResponse(CachedURLResponse(response: $0.response, data: $0.data), for: URLRequest(url: self.url))

                    return .success(Image(uiImage: value))
                }
                .catch { _ in
                    Just(.failure)
                }
                .receive(on: RunLoop.main)
                .assign(to: \.loadingState, on: self)
        }

    }

    private var cancellable: AnyCancellable?
}

