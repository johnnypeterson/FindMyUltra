//
//  ContentView.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/5/23.
//

import SwiftUI
import StoreKit

struct Home: View {
    @State private var viewModel = MapViewModel()
    @Environment(\.openURL) private var openURL
    @State private var isShowingFeedback = false

    var body: some View {
        TabView {
            MapView(viewModel: viewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            RaceList(viewModel: viewModel)
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Location Access is required to find races near you on the Map"),
                message: Text("Go to Settings?"),
                primaryButton: .default(Text("Settings"), action: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        openURL(settingsURL)
                    }
                }),
                secondaryButton: .default(Text("Cancel"))
            )
        }
        .overlay(alignment: .bottomLeading) {
            Button {
                isShowingFeedback = true
            } label: {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(Color.indigo)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Feedback and support")
            .shadow(radius: 4)
            .padding()
            .padding(.bottom, 64)
        }
        .sheet(isPresented: $isShowingFeedback) {
            FeedbackView()
                .presentationDetents([.medium])
        }
        .tint(.indigo)
        .task {
            await viewModel.fetchEvents()
        }
        .onAppear {
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

private struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview

    private let feedbackEmail = "johnnyswiftapps@gmail.com"

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.indigo)
                    .padding(.top, 8)

                VStack(spacing: 8) {
                    Text("Feedback & Support")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Share a quick rating or send suggestions directly to the developer.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    Button {
                        dismiss()
                        requestReview()
                    } label: {
                        Label("Rate on the App Store", systemImage: "star.bubble.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)

                    Button {
                        emailSuggestions()
                    } label: {
                        Label("Email Suggestions", systemImage: "envelope.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
                }
                .controlSize(.large)

                Spacer()
            }
            .padding()
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func emailSuggestions() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = feedbackEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "Find My Ultra Feedback"),
            URLQueryItem(name: "body", value: feedbackMessage)
        ]

        if let url = components.url {
            openURL(url)
        }
    }

    private var feedbackMessage: String {
        """


        App Version: \(Bundle.main.appVersion)
        iOS Version: \(UIDevice.current.systemVersion)
        Device: \(UIDevice.current.model)
        """
    }
}

extension Bundle {
    var appVersion: String {
        let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = object(forInfoDictionaryKey: "CFBundleVersion") as? String

        switch (version, build) {
        case let (version?, build?):
            return "\(version) (\(build))"
        case let (version?, nil):
            return version
        case let (nil, build?):
            return build
        default:
            return "Unknown"
        }
    }
}

#Preview {
    Home()
}
