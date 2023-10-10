//
//  FilterView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/9/23.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: MapViewModel
    var body: some View {
        Form {
            Picker("Month", selection: $viewModel.month) {
                    ForEach(Month.allCases) { option in
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
            Picker("Search Distance", selection: $viewModel.distanceFromMe) {
                    ForEach(DistanceFromMe.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
            .pickerStyle(.automatic)
            }
    }
}

#Preview {
    FilterView(viewModel: MapViewModel())
}
