//
//  MapViewModel.swift
//  UltraMapper
//
//  Created by Johnny Peterson on 10/5/23.
//

import Foundation
import MapKit
import _MapKit_SwiftUI

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.8911054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

@MainActor
final class MapViewModel: NSObject, CLLocationManagerDelegate,ObservableObject {
    var locationManger: CLLocationManager?
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    @Published var camameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan))
    @Published var data: [MapViewDO] = []
    @Published var locations: [Location] = []
    @Published private(set) var events: [Event] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    
    private let client = Client()
    
    
    func checkIfLocationServicesIsEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManger = CLLocationManager()
                self.locationManger!.delegate = self
            } else {
                //TODO: Location Alert needed
            }

    }
    private func checkLocationAuthorazaition() {
        guard let locationManger = locationManger else {return}
        switch locationManger.authorizationStatus {
            
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            //TODO Alert needed
            print("Location is restricted parental conrolls")
        case .denied:
            //TODO Alert needed
            print("Location is restricted parental conrolls")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManger.location {
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                camameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
            }
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorazaition()
    }
    func fetch() {
        data = [MapViewDO(name: "Datum 1"),
                MapViewDO(name: "Datum 2"),
                MapViewDO(name: "Datum 3")]
    }
    
//    var request: URLRequest = {
//        let urlString = "\(BASE_URL)/events.svc/closestevents?open=1&past=0&lat=34.9243051&lng=-80.7880559&mi=200&mo=12"
//        let url = URL(string: urlString)!
//        return URLRequest(url: url)
//    }()

    func fetchEvents() async {
        do {
            let urlString = "\(BASE_URL)/events.svc/closestevents"
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            request.url?.append(queryItems: [
            URLQueryItem(name: "open", value: "1"),
            URLQueryItem(name: "past", value: "0"),
            URLQueryItem(name: "lat", value: String(describing: locationManger?.location?.coordinate.latitude)),
            URLQueryItem(name: "lng", value: String(describing: locationManger?.location?.coordinate.longitude)),
            URLQueryItem(name: "mi", value: "10"),
            URLQueryItem(name: "mo", value: "12")])
            let response = try await client.fetch(type: Events.self, with: request)
            events = response.compactMap { $0 }
            events.forEach {
                let location = Location(name: $0.eventName, coordinate: CLLocationCoordinate2D(latitude:  Double($0.latitude) ?? 0.0,
                                                                                               longitude: Double($0.longitude) ?? 0.0), eventId: $0.id)
                locations.append(location)
                print(location)
            }
        } catch {
            errorMessage = "\((error as! ApiError).customDescription)"
            hasError = true
        }
    }
}


struct MapViewDO: Identifiable {
    let id = UUID()
    var name: String
}
