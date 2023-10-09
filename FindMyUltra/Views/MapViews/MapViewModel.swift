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
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 3.0, longitudeDelta: 3.0)
}

@MainActor
final class MapViewModel: NSObject, CLLocationManagerDelegate,ObservableObject {
    var locationManger: CLLocationManager?
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var overrideRegion = MKCoordinateRegion()
    @Published var camameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan))
    @Published var data: [MapViewDO] = []
    @Published var locations: [Location] = []
    @Published private(set) var events: [Event] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published var difficultyPicker: Difficulty = .unranked
    @Published var raceDistance: RaceDistance = .showAll
    @Published var distanceFromMe: DistanceFromMe = .twoHundred
    @Published var month: Month = .showAll
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText = ""
    @Published  var overrideAddres: AddressResult?
    @Published var annotationItems: [AnnotationItem] = []
    
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
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.05, longitudeDelta: 1.05))
                camameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.05, longitudeDelta: 1.05)))
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
    
    func fetchEvents() async {
    
            do {
               let request = request()
                let response = try await client.fetch(type: Events.self, with: request)
                events.removeAll()
                locations.removeAll()
                events = response.compactMap { $0 }
                events.forEach {
                    let location = Location(name: $0.eventName, coordinate: CLLocationCoordinate2D(latitude:  Double($0.latitude) ?? 0.0, longitude: Double($0.longitude) ?? 0.0), eventId: $0.id, event: $0)
                    locations.append(location)
                }
            } catch {
                errorMessage = "\((error as! ApiError).customDescription)"
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
        if let lat = locationManger?.location?.coordinate.latitude, let lng = locationManger?.location?.coordinate.longitude{
             request.url?.append(queryItems: [
                URLQueryItem(name: "lat", value: String(describing: lat)),
                URLQueryItem(name: "lng", value: String(describing: lng)),
                URLQueryItem(name: "mi", value:  distanceFromMe.network),
                URLQueryItem(name: "mo", value: "12")
                
            ])
            if raceDistance != .showAll {
                let dist = URLQueryItem(name: "dist", value: raceDistance.network)
                request.url?.append(queryItems: [dist])
            }
            if month != .showAll {
                let m = URLQueryItem(name: "m", value: month.network)
                request.url?.append(queryItems: [m])
            }
            print("REQUEST: \(request)")
            return request
        
            
        }
        return request
    }
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
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
            let response = try await MKLocalSearch(request: request).start()
            await MainActor.run {
                self.annotationItems = response.mapItems.map {
                    AnnotationItem(
                        latitude: $0.placemark.coordinate.latitude,
                        longitude: $0.placemark.coordinate.longitude
                    )
                }
                
                self.region = response.boundingRegion
            }
        }
    }
}

extension MapViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
        


struct MapViewDO: Identifiable {
    let id = UUID()
    var name: String
}
