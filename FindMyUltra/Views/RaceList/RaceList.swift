//
//  RaceList.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI

struct RaceList: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var viewModel:MapViewModel
    @State var events = [Event]()
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
        NavigationView {
            if events.isEmpty {
                ProgressView()
                    .scaleEffect(CGFloat(1.0), anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.indigo))
                    .padding(.bottom, 50)
            } else {
                List(searchResults) { event in
                    NavigationLink(destination: RaceDetails(event: event)) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: "https://s3.amazonaws.com/img.ultrasignup.com/event/banner/\(event.bannerID).jpg")) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "photo")
                                        .frame(width: 70, height: 50)
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 70, maxHeight: 50)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 70, height: 50)
                                @unknown default:
                                    EmptyView()
                                        .frame(width: 70, height: 50)
                                }
                            }
                            .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 10) {
                                Text(event.eventName)
                                    .fontWeight(.semibold)
                                Label {
                                    Text("\(event.distances) - \(event.city), \(event.state)")
                                } icon: {
                                    Image(systemName: "figure.run")
                                }
                                .font(.caption)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText)
                .navigationTitle("Race List")
                .toolbar {
                    Button {
                        showAnotherSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.indigo)
                        
                    }
                }
            }
            
        }

        .sheet(isPresented: $showAnotherSheet) {
            NavigationView {
                Text("Filter Shit")
                    .navigationBarItems(trailing: Button("Apply Filters",
                                                         action: {showAnotherSheet.toggle()
                        //TODO: Recall service
                    }))
            }
        }
        .onAppear{
            events = viewModel.events
        }
       
    }
    
}

#Preview {
    RaceList(viewModel: MapViewModel())
}


  

