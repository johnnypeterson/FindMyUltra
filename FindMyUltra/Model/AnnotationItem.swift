//
//  AnnotationItem.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/9/23.
//


import Foundation
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
