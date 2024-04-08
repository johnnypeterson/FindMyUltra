//
//  AddressRow.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 4/8/24.
//

import Foundation
import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    
    var body: some View {
//        NavigationLink {
//            MapView(address: address)
//        } label: {
            VStack(alignment: .leading) {
                Text(address.title)
                Text(address.subtitle)
                    .font(.caption)
            }
//        }
        .padding(.bottom, 2)
    }
}
