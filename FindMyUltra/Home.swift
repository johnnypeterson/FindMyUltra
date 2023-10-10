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
        .alert(isPresented: $viewModel.showAlert) {
             Alert (title: Text("Location Access is required to find races near you on the Map"),
                    message: Text("Go to Settings?"),
                    primaryButton: .default(Text("Settings"), action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }),
                    secondaryButton: .default(Text("Cancel")))
                }
        .accentColor(.indigo)
        .task {
           
                await viewModel.fetchEvents()
            
        }
        .onAppear{
            viewModel.checkIfLocationServicesIsEnabled()
            
            
        }
        
    }
}

#Preview {
    Home()
}
