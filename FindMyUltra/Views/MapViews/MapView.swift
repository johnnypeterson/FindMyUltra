//
//  MapView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI
import _MapKit_SwiftUI

struct MapView: View {
   
    @ObservedObject var viewModel: MapViewModel
    @Environment(\.openURL) var openURL
    @State private var searchText = ""
    @State var showAnotherSheet: Bool = false
    @State var showDetailsSheet: Bool = false
    @State var selectedEvent:Event?
    var searchResults: [Event] {
        if searchText.isEmpty {
            return viewModel.events
        } else {
            return viewModel.events.filter { $0.eventName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    @State var address: AddressResult?
    
    
    var body: some View {
        NavigationStack {
           
                Map(position: $viewModel.camameraPosition) {
                    ForEach(viewModel.locations,id: \.id) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.orange.opacity(0.5))
                                    .frame(width: 80, height: 80)
                                Image(systemName: "figure.run.circle")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                                    .onTapGesture{
                                        selectedEvent = location.event
                                        showDetailsSheet.toggle()
                                    }
                            }
                        }
                        .annotationTitles(.visible)
                    }
                    ForEach(viewModel.annotationItems,id: \.id) { item in
                        Annotation("Home", coordinate: item.coordinate) {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.purple.opacity(0.5))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "house.circle.fill")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(Color.purple)
                                    .clipShape(Circle())
                                    }
                            }
                        }
                    .annotationTitles(.visible)
                }
                

                
                .sheet(isPresented: $showDetailsSheet) {
                    if let event = selectedEvent {
                        VStack{
                            Text(event.eventName)
                                .bold()
                                .font(.title)
                            RaceDetails(event: event)
                        }
                    }
                }
                .sheet(isPresented: $showAnotherSheet) {
                    NavigationView {
                        FilterView(viewModel: viewModel)
                            .navigationBarItems(trailing: Button("Apply Filters",
                                                                 action: {showAnotherSheet.toggle()
                                if let address = viewModel.selectedAddress {
                                    viewModel.getPlace(from: address)
                                }
                            
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
                .ignoresSafeArea()
                .safeAreaInset(edge: .bottom) {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 110)
                }
              
            
        }
    }
}

#Preview {
    MapView(viewModel: MapViewModel())
        
}




