//
//  SegmentBar.swift
//  ProductBrand
//
//  Created by Anand  on 14/02/23.
//

import SwiftUI

enum SegmentSection : String, CaseIterable {
    case all = "All"
    case favorite = "Favourites"
}

struct SegmentBar: View {
    
    @Binding var state: Int
    
    @State var segmentationSelection : SegmentSection = .all
    
    var body: some View {
        Picker("", selection: $segmentationSelection) {
                   ForEach(SegmentSection.allCases, id: \.self) { option in
                       Text(option.rawValue)
                   }
            }
        .accessibility(identifier: "picker")
        .pickerStyle(SegmentedPickerStyle())
        .padding(60)
        .onChange(of: segmentationSelection) { newValue in
            let index = SegmentSection.allCases.firstIndex(of: newValue)
            state = index ?? 0
        }
    }
}

struct SegmentBar_Previews: PreviewProvider {
    static var previews: some View {
        let section  = 0
        SegmentBar(state: .constant(section))
    }
}
