//
//  MapView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI
import MapKit

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

    private var annotations: [CombinedAnnotation] {
        let eventAnnotations = viewModel.locations.map { CombinedAnnotation.event($0) }
        let homeAnnotations = viewModel.annotationItems.map { CombinedAnnotation.home($0) }
        return eventAnnotations + homeAnnotations
    }
    
    
    var body: some View {
        NavigationStack {

                Map(coordinateRegion: $viewModel.region, annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        switch annotation {
                        case .event(let location):
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
                            .accessibilityLabel(location.name)
                        case .home:
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
                            .accessibilityLabel("Home")
                        }
                    }
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
                    NavigationStack {
                        FilterView(viewModel: viewModel)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Apply Filters", action: {
                                        showAnotherSheet.toggle()
                                        if let address = viewModel.selectedAddress {
                                            viewModel.getPlace(from: address)
                                        }
                                    })
                                }
                            }
                    }
                }
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        showAnotherSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color.indigo)
                            .padding()
                            .background(.regularMaterial)
                            .clipShape(Circle())

                    }
                    .padding()
                    .padding(.bottom, 100)
                    .shadow(radius: 4)

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

private enum CombinedAnnotation: Identifiable {
    case event(Location)
    case home(AnnotationItem)

    var id: UUID {
        switch self {
        case .event(let location):
            return location.id
        case .home(let annotationItem):
            return annotationItem.id
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .event(let location):
            return location.coordinate
        case .home(let annotationItem):
            return annotationItem.coordinate
        }
    }
}

#Preview {
    MapView(viewModel: MapViewModel())
        
}




