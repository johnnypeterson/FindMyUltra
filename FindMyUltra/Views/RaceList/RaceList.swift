//
//  RaceList.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI

struct RaceList: View {
    @Environment(\.openURL) var openURL
 
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
            ScrollView{
                raceList()
                    .padding()
            }
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
