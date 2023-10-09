//
//  FilterView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/9/23.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: MapViewModel
    @FocusState private var isFocusedTextField: Bool
    @State private var selectedAddress: AddressResult?
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            TextField("Type address", text: $viewModel.searchableText)
//                .padding()
//                .autocorrectionDisabled()
//                .focused($isFocusedTextField)
//                .font(.title)
//                .onReceive(
//                    viewModel.$searchableText.debounce(
//                        for: .seconds(0.1),
//                        scheduler: DispatchQueue.main
//                    )
//                ) {
//                    viewModel.searchAddress($0)
//                }
//                .background(Color.init(uiColor: .systemBackground))
//                .overlay {
//                    ClearButton(text: $viewModel.searchableText)
//                        .padding(.trailing)
//                        .padding(.top, 8)
//                }
//                .onAppear {
//                    isFocusedTextField = true
//                }
//            List(self.viewModel.results) { address in
//                AddressRow(address: address)
//                    .listRowBackground(address == selectedAddress ? Color.indigo : backgroundColor)
//                    .onTapGesture {
//                        viewModel.overrideAddres = address
//                        selectedAddress = address
//                       
//                             }
//            
//
//            }
//            .listStyle(.plain)
//            .scrollContentBackground(.hidden)
            Form {
                Picker("Month", selection: $viewModel.month) {
                    ForEach(Month.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
                Picker("Distance", selection: $viewModel.raceDistance) {
                    ForEach(RaceDistance.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
                Picker("Search Distance", selection: $viewModel.distanceFromMe) {
                    ForEach(DistanceFromMe.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
            }
        }
    }
}

#Preview {
    FilterView(viewModel: MapViewModel())
}
