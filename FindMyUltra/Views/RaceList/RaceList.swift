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
    @State private var searchText = ""
    @State var showAnotherSheet: Bool = false
    var searchResults: [Event] {
        if searchText.isEmpty {
            return viewModel.events
        } else {
            return viewModel.events.filter { $0.eventName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.events.isEmpty {
                ProgressView()
                    .scaleEffect(CGFloat(2.0), anchor: .center)
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

                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.eventName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                Label("\(event.distances) \u{00B7} \(event.city), \(event.state) \u{00B7} \(event.eventDate)", systemImage: "figure.run")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }
                    .listRowSeparator(.hidden)
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
              FilterView(viewModel: viewModel)
                    .navigationBarItems(trailing: Button("Apply Filters",
                                                         action: {showAnotherSheet.toggle()
                        Task{
                            await
                            viewModel.fetchEvents()
                        }
                    }))
            }
        }
       
    }
    
}

#Preview {
    RaceList(viewModel: MapViewModel())
}


  

