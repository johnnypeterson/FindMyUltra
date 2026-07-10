//
//  RaceDetails.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/6/23.
//

import SwiftUI
import StoreKit

struct RaceDetails: View {
    var event: Event
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("reviewPromptActionCount") private var reviewPromptActionCount = 0
    @AppStorage("lastReviewPromptedAppVersion") private var lastReviewPromptedAppVersion = ""
    @AppStorage("hasPendingReviewPrompt") private var hasPendingReviewPrompt = false

    private let reviewPromptThreshold = 2

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

            Text(event.eventName)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                Text("Distances: \(event.distances)")
                Text("City: \(event.city)")
                Text("Date: \(event.eventDate)")
            }
            .font(.subheadline)
       
            Button("Directions") {
                if let url = URL(string: "maps://?saddr=&daddr=\(event.latitude),\(event.longitude)") {
                    trackReviewPromptAction()
                    openURL(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
              
            Button("Register") {
                if let url = URL(string: "https://ultrasignup.com/register.aspx?eid=\(event.id)") {
                    trackReviewPromptAction()
                    openURL(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            
            
           
        }
        .navigationTitle(event.eventName)
        .onChange(of: scenePhase) {
            requestReviewIfReady()
        }
    }

    private func trackReviewPromptAction() {
        reviewPromptActionCount += 1

        if shouldRequestReview {
            hasPendingReviewPrompt = true
        }
    }

    private func requestReviewIfReady() {
        guard scenePhase == .active, shouldRequestReview, hasPendingReviewPrompt else { return }

        hasPendingReviewPrompt = false
        lastReviewPromptedAppVersion = Bundle.main.appVersion

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.7))
            requestReview()
        }
    }

    private var shouldRequestReview: Bool {
        reviewPromptActionCount >= reviewPromptThreshold
        && lastReviewPromptedAppVersion != Bundle.main.appVersion
    }
}

#Preview {
    RaceDetails(event: Event(bannerID: "9c07ee03-42c6-45be-9a66-3fe7c8e4611c", cancelled: false, city: "Mount plesant", distanceCategories: .ultra, distances: "24hrs, 12hrs, 6hrs", eventDate: "10/7/2023", eventDateEnd: nil, eventDateID: 52918, eventDateOriginal: "10/7/2023", eventDistances: nil, id: 16544, eventImages: [EventImage(imageID: "ff519604-2edb-4ca8-b86e-93f94c92f2d9", imageLabel: nil)], eventName: "The Midnight Dreary", eventType: 0, eventWebsite: "https://jsmossservices.wixsite.com/intentionalmovement", groupID: 0, groupName: nil, latitude: "32.8013", location: "", longitude: "-79.8888", postponed: false, state: "SC", virtualEvent: false))
}
