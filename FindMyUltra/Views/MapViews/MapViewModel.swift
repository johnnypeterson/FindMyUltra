//
//  MapViewModel.swift
//  UltraMapper
//
//  Created by Johnny Peterson on 10/5/23.
//

import Foundation
import MapKit
import Observation
import SwiftUI

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.8911054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 3.0, longitudeDelta: 3.0)
}

@MainActor
@Observable
final class MapViewModel: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored private var locationManager: CLLocationManager?
    @ObservationIgnored private let client = Client()
    @ObservationIgnored private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()

    var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    )
    var selectedAddress: AddressResult?
    var data: [MapViewDO] = []
    var locations: [Location] = []
    private(set) var events: [Event] = []
    private(set) var errorMessage: String = ""
    var hasError: Bool = false
    var difficulty: Difficulty = .unranked
    var raceDistance: RaceDistance = .showAll
    /// Selected radius for searches around the chosen location.
    var searchRadius: SearchRadius = .twoHundred
    var month: Month = .showAll
    var showAlert = false
    private(set) var results: [AddressResult] = []
    var searchableText = ""
    var annotationItems: [AnnotationItem] = []
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            let manager = CLLocationManager()
            manager.delegate = self
            locationManager = manager
        } else {
            showAlert = true
        }

    }
    func checkLocationAuthorization() {
        guard let locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert = true
            print("Location is restricted parental controls")
        case .denied:
            showAlert = true
            print("Location is restricted parental controls")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.checkLocationAuthorization()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else { return }
            if self.selectedAddress != nil {
                self.region = MKCoordinateRegion(center: self.region.center, span: MKCoordinateSpan(latitudeDelta: 1.05, longitudeDelta: 1.05))
            } else {
                self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.05, longitudeDelta: 1.05))
            }
            self.cameraPosition = .region(self.region)
            self.locationManager?.stopUpdatingLocation()
            await self.fetchEvents()
        }
    }
    func fetch() {
        data = [MapViewDO(name: "Datum 1"),
                MapViewDO(name: "Datum 2"),
                MapViewDO(name: "Datum 3")]
    }
    
    func fetchEvents() async {
    
            do {
               let request = request()
                let response = try await client.fetch(type: Events.self, with: request)
                events = response.compactMap { $0 }
                locations = events.map {
                    Location(name: $0.eventName, coordinate: CLLocationCoordinate2D(latitude: Double($0.latitude) ?? 0.0, longitude: Double($0.longitude) ?? 0.0), eventId: $0.id, event: $0)
                }
            } catch {
                if let apiError = error as? ApiError {
                    errorMessage = apiError.customDescription
                } else {
                    errorMessage = error.localizedDescription
                }
                hasError = true
            }
    }
    
    func request() -> URLRequest {
        let urlString = "\(BASE_URL)/events.svc/closestevents"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.url?.append(queryItems: [
           URLQueryItem(name: "open", value: "1"),
           URLQueryItem(name: "past", value: "0")
           ])
        if let item = annotationItems.first {
            request.url?.append(queryItems: [
                URLQueryItem(name: "lat", value: String(describing: item.latitude)),
                URLQueryItem(name: "lng", value: String(describing: item.longitude)),
                URLQueryItem(name: "mi", value:  searchRadius.network),
                URLQueryItem(name: "mo", value: "12")

           ])
        } else {
            request.url?.append(queryItems: [
                URLQueryItem(name: "lat", value: String(describing: region.center.latitude)),
                URLQueryItem(name: "lng", value: String(describing: region.center.longitude)),
                URLQueryItem(name: "mi", value:  searchRadius.network),
                URLQueryItem(name: "mo", value: "12")

            ])
        }
        
        if raceDistance != .showAll {
            let dist = URLQueryItem(name: "dist", value: raceDistance.network)
            request.url?.append(queryItems: [dist])
        }
        if month != .showAll {
            let m = URLQueryItem(name: "m", value: month.network)
            request.url?.append(queryItems: [m])
        }
        if difficulty != .unranked {
            let diff = URLQueryItem(name: "difficulty", value: difficulty.network)
            request.url?.append(queryItems: [diff])
        }
        return request
    }
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
    func getPlace(from address: AddressResult) {
       
        let request = MKLocalSearch.Request()
        let title = address.title
        let subTitle = address.subtitle
        
        request.naturalLanguageQuery = subTitle.contains(title)
        ? subTitle : title + ", " + subTitle
        
        Task {
            do {
                let response = try await MKLocalSearch(request: request).start()
                self.annotationItems = response.mapItems.map {
                    AnnotationItem(
                        latitude: $0.placemark.coordinate.latitude,
                        longitude: $0.placemark.coordinate.longitude
                    )
                }
                
                self.region = response.boundingRegion
                self.cameraPosition = .region(response.boundingRegion)
                checkLocationAuthorization()
                await fetchEvents()
            } catch {
                errorMessage = error.localizedDescription
                hasError = true
            }
        }
    }

  
}

extension MapViewModel: MKLocalSearchCompleterDelegate {
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.map {
            AddressResult(title: $0.title, subtitle: $0.subtitle)
        }

        Task { @MainActor in
            self.results = results
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
        


struct MapViewDO: Identifiable {
    let id = UUID()
    var name: String
}
