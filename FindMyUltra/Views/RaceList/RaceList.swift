//
//  RaceList.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI

struct RaceList: View {
    @Environment(\.openURL) var openURL
    @StateObject private var viewModel = MapViewModel()
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
            ScrollView{
                if events.isEmpty {
                    ProgressView()
                        .scaleEffect(CGFloat(1.0), anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.indigo))
                        .padding(.bottom, 50)
                } else {
                    raceList()
                        .padding()
                }
            }
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
        .sheet(isPresented: $showAnotherSheet) {
            NavigationView {
                Text("Filter Shit")
                    .navigationBarItems(trailing: Button("Apply Filters",
                                                         action: {showAnotherSheet.toggle()
                    //TODO: Recall service
                    }))
            }
        }
        .task {
            await viewModel.fetchEvents()
            events = viewModel.events
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder
    func raceList() -> some View {
        VStack(spacing: 25) {
            ForEach(searchResults) { event in
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: "https://s3.amazonaws.com/img.ultrasignup.com/event/banner/\(event.bannerID).jpg"))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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
                    Button {
                        openURL(URL(string: "https://ultrasignup.com/register.aspx?eid=\(event.id)")!)
                    } label : {
                       
                        Text("register")
                        
                           
                    }
                    .controlSize(.mini)
                }
            }
        }
        .padding(.top, 15)
        
    }

}

#Preview {
    RaceList()
}
