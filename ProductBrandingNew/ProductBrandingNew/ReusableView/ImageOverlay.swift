//
//  ImageOverlay.swift
//  ProductBrandingNew
//
//  Created by Anand  on 18/02/23.
//

import SwiftUI

/// ImageOverlayDelegate

protocol ImageOverlayDelegate {
    ///  on favorite action invoke this method
    func didSelectFavorite(_ productId: String, _ status: Bool)
}

struct ImageOverlay: View {
    var delegate: ImageOverlayDelegate?
    var productID: String
    @Binding var isSelected: Bool
    @State var imageName: String = "heart"
    
    var body: some View {
        ZStack {
            Button(action: {
                isSelected.toggle()
                imageName = isSelected ? "heart_sel" : "heart"
                delegate?.didSelectFavorite(productID, isSelected)
                
            }) {
                Image(imageName)
                    .renderingMode(.original)
            }
            .frame(width: 40, height: 40)
            .buttonStyle(.borderless)
        }
        .opacity(1.0)
        .cornerRadius(20.0)
        .padding()
        .onAppear {
            imageName = isSelected ? "heart_sel" : "heart"
        }
    }
}

