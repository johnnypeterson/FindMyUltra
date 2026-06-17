//
//  FilterView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/9/23.
//

import SwiftUI

struct FilterView: View {
    @Bindable var viewModel: MapViewModel
    @FocusState private var isFocusedTextField: Bool
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
    @State private var selectedAddress: AddressResult?
    @State private var searchTask: Task<Void, Never>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Type address", text: $viewModel.searchableText)
                .padding()
                .autocorrectionDisabled()
                .focused($isFocusedTextField)
                .font(.title)
                .onChange(of: viewModel.searchableText) { _, text in
                    searchTask?.cancel()
                    searchTask = Task {
                        try? await Task.sleep(for: .seconds(1))
                        guard !Task.isCancelled else { return }
                        await MainActor.run {
                            viewModel.searchAddress(text)
                        }
                    }
                }
                .background(Color.init(uiColor: .systemBackground))
                .overlay {
                    ClearButton(text: $viewModel.searchableText)
                        .padding(.trailing)
                        .padding(.top, 8)
                }
                .onAppear {
                    isFocusedTextField = true
                }
                .onDisappear {
                    searchTask?.cancel()
                }
            List(viewModel.results) { address in
                AddressRow(address: address)
               
                    .listRowBackground(address ==  viewModel.selectedAddress ? Color.purple : nil)
                    .onTapGesture {
                        viewModel.selectedAddress = address
                                  }
            }
         
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            Form {
                Picker("Month", selection: $viewModel.month) {
                    ForEach(Month.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
                .pickerStyle(.automatic)
                Picker("Difficulty", selection: $viewModel.difficulty) {
                    ForEach(Difficulty.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
                .pickerStyle(.automatic)
                Picker("Distance", selection: $viewModel.raceDistance) {
                    ForEach(RaceDistance.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
                .pickerStyle(.automatic)
                Picker("Search Radius", selection: $viewModel.searchRadius) {
                    ForEach(SearchRadius.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
                .pickerStyle(.automatic)
            }
        }
    }
}

#Preview {
    FilterView(viewModel: MapViewModel())
}
