//
//  RaceDetails.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/6/23.
//

import SwiftUI

struct RaceDetails: View {
    var event:Event
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            AsyncImage(url: URL(string: "https://s3.amazonaws.com/img.ultrasignup.com/event/banner/\(event.bannerID).jpg")) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                case .failure:
                    Image(systemName: "photo")
                        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                @unknown default:
                    EmptyView()
                        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                }
                   
            }
      
//            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .top)
       
            Text("Distances: \(event.distances)")
            Text("City: \(event.city)")
            Text("Date: \(event.eventDate)")
       
            Button {
                let url = URL(string: "maps://?saddr=&daddr=\(event.latitude),\(event.longitude)")
                if UIApplication.shared.canOpenURL(url!) {
                      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            } label : {
                
                Text("Directions")
                    .foregroundColor(.white)
                
                
            }
            .frame(maxWidth: 150)
            .padding()
               .background(.indigo)
               .clipShape(Capsule())
               .controlSize(.large)
              
            Button {
                openURL(URL(string: "https://ultrasignup.com/register.aspx?eid=\(event.id)")!)
            } label : {
                
                Text("Register")
                    .foregroundColor(.white)
                
                
            }
            .frame(maxWidth: 150)
            .padding()
               .background(.indigo)
               .clipShape(Capsule())
               .controlSize(.large)
            
            
           
        }
        .font(.title3)
        .navigationTitle(event.eventName)
        
        
    }
}

#Preview {
    RaceDetails(event: Event(bannerID: "9c07ee03-42c6-45be-9a66-3fe7c8e4611c", cancelled: false, city: "Mount plesant", distanceCategories: .ultra, distances: "24hrs, 12hrs, 6hrs", eventDate: "10/7/2023", eventDateEnd: nil, eventDateID: 52918, eventDateOriginal: "10/7/2023", eventDistances: nil, id: 16544, eventImages: [EventImage(imageID: "ff519604-2edb-4ca8-b86e-93f94c92f2d9", imageLabel: nil)], eventName: "The Midnight Dreary", eventType: 0, eventWebsite: "https://jsmossservices.wixsite.com/intentionalmovement", groupID: 0, groupName: nil, latitude: "32.8013", location: "", longitude: "-79.8888", postponed: false, state: "SC", virtualEvent: false))
}
