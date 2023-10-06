//
//  MapView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI
import _MapKit_SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
 
    @Environment(\.openURL) var openURL
    @State var difficultyPicker: Difficulty = .unranked
    @State var raceDistance: RaceDistance = .oneHundredPlus
    @State var events = [Event(bannerID: "9c07ee03-42c6-45be-9a66-3fe7c8e4611c", cancelled: false, city: "Mount plesant", distanceCategories: .ultra, distances: "24hrs, 12hrs, 6hrs", eventDate: "10/7/2023", eventDateEnd: nil, eventDateID: 52918, eventDateOriginal: "10/7/2023", eventDistances: nil, id: 16544, eventImages: [EventImage(imageID: "ff519604-2edb-4ca8-b86e-93f94c92f2d9", imageLabel: nil)], eventName: "The Midnight Dreary", eventType: 0, eventWebsite: "https://jsmossservices.wixsite.com/intentionalmovement", groupID: 0, groupName: nil, latitude: "32.8013", location: "", longitude: "-79.8888", postponed: false, state: "SC", virtualEvent: false), Event(bannerID: "9c07ee03-42c6-45be-9a66-3fe7c8e4611c", cancelled: false, city: "Mount plesant", distanceCategories: .ultra, distances: "24hrs, 12hrs, 6hrs", eventDate: "10/7/2023", eventDateEnd: nil, eventDateID: 52918, eventDateOriginal: "10/7/2023", eventDistances: nil, id: 12968, eventImages: [EventImage(imageID: "ff519604-2edb-4ca8-b86e-93f94c92f2d9", imageLabel: nil)], eventName: "Fuck This Race", eventType: 0, eventWebsite: "https://jsmossservices.wixsite.com/intentionalmovement", groupID: 0, groupName: nil, latitude: "32.8013", location: "", longitude: "-79.8888", postponed: false, state: "SC", virtualEvent: false)]
    @State private var searchText = ""
    @State var showAnotherSheet: Bool = false
    var searchResults: [Event] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { $0.eventName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
        NavigationStack {
            Map(position: $viewModel.camameraPosition) {
                ForEach(viewModel.locations,id: \.id) { location in
                    Annotation(location.name,
                               coordinate: location.coordinate) {
                        ZStack {
                             Circle()
                                 .foregroundStyle(.orange.opacity(0.5))
                                 .frame(width: 80, height: 80)
                             Image(systemName: "figure.run.circle")
                                 .symbolEffect(.variableColor)
                                 .padding()
                                 .foregroundStyle(.white)
                                 .background(Color.orange)
                                 .clipShape(Circle())
                                 .onTapGesture{
                                     openURL(URL(string: "https://ultrasignup.com/register.aspx?eid=\(location.eventId)")!)
                                 }
                         }
                    
                     
                
                    }
                               .annotationTitles(.visible)
                              
                }
            }
        
            .sheet(isPresented: $showAnotherSheet) {
                NavigationView {
                    filterView()
                        .navigationBarItems(trailing: Button("Apply Filters",
                                                             action: {showAnotherSheet.toggle()
                        //TODO: Recall service
                        }))
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
            Button {
                showAnotherSheet.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.indigo)
                    
            }
            .padding()
            .padding(.bottom, 100)
            
        })

            .mapStyle(.hybrid)

                .task {
                    await viewModel.fetchEvents()
                    events = viewModel.events
                }
                .onAppear{
                    viewModel.checkIfLocationServicesIsEnabled()
                    
                }
                .ignoresSafeArea()
                .safeAreaInset(edge: .bottom) {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 110)
                }
        }
    }

    @ViewBuilder
    func filterView() -> some View {
        Form {
            Picker("Difficulty", selection: $difficultyPicker) {
                    ForEach(Difficulty.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
            Picker("Distance", selection: $raceDistance) {
                    ForEach(RaceDistance.allCases) { option in
                        Text(String(describing: option))
                            .tag(option)
                    }
                }
            }
        }
}

#Preview {
    MapView()
        
}




