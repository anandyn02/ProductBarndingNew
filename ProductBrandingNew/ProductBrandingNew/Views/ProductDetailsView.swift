//
//  ProductDetailsView.swift
//  ProductBrandingNew
//
//  Created by Anand  on 19/02/23.
//

import SwiftUI

struct ProductDetailsView: View {
  
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var product: Product
    @Binding var isScreenUpdated: Bool
    @State private var showsAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            URLImage(urlString: product.imageURL)
                .frame(width: UIScreen.main.bounds.width, height: 200)
            
            Text(product.title)
                .foregroundColor(.black)
                .font(.title3)
            
            HStack(spacing: 10) {
                Text("Price: $\(String(format: "%.2f", product.price.first?.value ?? 0))")
                    .foregroundColor(.black)
                    .font(.body)
                Spacer()
                Button(action: {
                    self.showsAlert.toggle()
                }, label: {
                    Text("Add Cart")
                })
                .buttonStyle(.borderless)
                .alert(isPresented: self.$showsAlert) {
                    Alert(title: Text("\(product.title) added to cart"))
                }
                .frame(width: 100, height: 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                
            }
            
            Text("Rating: $\(String(format: "%.2f", product.rating ))")
                .foregroundColor(.black)
                .font(.title3)
            
            Spacer()
            
        }
        .padding()
        .navigationTitle(product.title)
        .overlay(ImageOverlay(delegate: nil,
                              productID: product.productId,
                              isSelected: $product.isFavorite), alignment: .topTrailing)
        .onAppear {
            isScreenUpdated = false
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            isScreenUpdated  = true
            self.presentationMode.wrappedValue.dismiss()
        }, label: { Image(systemName: "arrow.left") }))
        .navigationBarTitle("", displayMode: .inline)
    }
}
