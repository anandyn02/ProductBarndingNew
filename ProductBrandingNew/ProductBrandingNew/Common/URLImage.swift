//
//  URLImage.swift
//  ProductBrand
//
//  Created by Anand  on 14/02/23.
//

import SwiftUI

struct URLImage: View {
    
    @ObservedObject private var remoteImage: RemoteImage
    
    init(urlString: String) {
        if  let url = URL(string: urlString) {
            remoteImage = RemoteImage(url: url)
        } else if let image_url = Bundle.main.url(forResource: "fall_leaves", withExtension: "png") {
            remoteImage = RemoteImage(url: image_url)
        }
        else {
            remoteImage = RemoteImage(url: URL(fileURLWithPath: ""))
        }
        remoteImage.load()

    }
    
    init(url: URL) {
        remoteImage = RemoteImage(url: url)
        remoteImage.load()
    }
    
    var body: some View {
        ZStack {
            switch remoteImage.loadingState {
            case .initial:
                EmptyView()
            case .inProgress:
                Text("Loading")
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Text("Failed")
            }
        }
    }
    
    
}
