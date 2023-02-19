//
//  ProductBrandingNewApp.swift
//  ProductBrandingNew
//
//  Created by Anand  on 18/02/23.
//

import SwiftUI

@main
struct ProductBrandingNewApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: ProductViewModel())
        }
    }
}
