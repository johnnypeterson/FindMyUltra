//
//  Location.swift
//  UltraMapper
//
//  Created by Johnny Peterson on 10/5/23.
//

import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let eventId: Int
}
