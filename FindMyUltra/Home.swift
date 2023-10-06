//
//  ContentView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            RaceList()
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }
        }
    }
}

#Preview {
    Home()
}
