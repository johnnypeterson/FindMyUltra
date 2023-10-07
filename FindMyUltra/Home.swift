//
//  ContentView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI

struct Home: View {
    @StateObject private var viewModel = MapViewModel()
    var body: some View {
        TabView {
            MapView(viewModel: viewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            RaceList(viewModel: viewModel)
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }
        }
        .accentColor(.indigo)
        .task {
            await viewModel.fetchEvents(raceDistance: nil, raceDifficulty: nil)
        }
        .onAppear{
            viewModel.checkIfLocationServicesIsEnabled()
            
            
        }
        
    }
}

#Preview {
    Home()
}
