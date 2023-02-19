//
//  DashboardView.swift
//  ProductBrandingNew
//
//  Created by Anand  on 18/02/23.
//

import SwiftUI

struct DashboardView: View {
   
    enum SegmentSection: Int {
        case all
        case favourites
        
        var desc: String {
            switch self {
            case .all: return "All"
            case .favourites: return "Favourites"
            }
        }
    }
    
    @ObservedObject var viewModel: ProductViewModel
    @State var didRefresh: Bool = false

    var body: some View {
        
        ZStack {
            if self.viewModel.isAppLoading {
                ProgressView().zIndex(1)
            }
            
            NavigationView {
                let list = (viewModel.segmentCurrentIndex == 0) ? $viewModel.products.items : $viewModel.favoriteItems
                List {
                    ForEach (list, id: \.id) { item in
                        ProductView(delegate: self, product: item, isScreenUpdated: $viewModel.isScreenDirty)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        SegmentBar(state: $viewModel.segmentCurrentIndex)
                    }
                }
                .navigationTitle(SegmentSection(rawValue: viewModel.segmentCurrentIndex)?.desc ?? "")
               
            }.zIndex(0)
        }

        .onAppear{
            viewModel.apply(input: .onAppear)
            viewModel.isScreenDirty = false
        }
        
    }
}

extension DashboardView: ImageOverlayDelegate {
    
    func didSelectFavorite(_ productId: String, _ status: Bool) {
        viewModel.refreshProductItem(for: productId, status: status)
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: ProductViewModel())
    }
}
