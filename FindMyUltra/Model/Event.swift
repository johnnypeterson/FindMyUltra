//
//  Event.swift
//  UltraMapper
//
//  Created by Johnny Peterson on 10/4/23.
//

import Foundation

// MARK: - Event
struct Event: Codable, Identifiable {
    let bannerID: String
    let cancelled: Bool
    let city: String
    let distanceCategories: DistanceCategories
    let distances, eventDate: String
    let eventDateEnd: String?
    let eventDateID: Int
    let eventDateOriginal: String
    let eventDistances: String?
    let id: Int
    let eventImages: [EventImage]
    let eventName: String
    let eventType: Int
    let eventWebsite: String
    let groupID: Int
    let groupName: String?
    let latitude, location, longitude: String
    let postponed: Bool
    let state: String
    let virtualEvent: Bool


    enum CodingKeys: String, CodingKey {
        case bannerID = "BannerId"
        case cancelled = "Cancelled"
        case city = "City"
        case distanceCategories = "DistanceCategories"
        case distances = "Distances"
        case eventDate = "EventDate"
        case eventDateEnd = "EventDateEnd"
        case eventDateID = "EventDateId"
        case eventDateOriginal = "EventDateOriginal"
        case eventDistances = "EventDistances"
        case id = "EventId"
        case eventImages = "EventImages"
        case eventName = "EventName"
        case eventType = "EventType"
        case eventWebsite = "EventWebsite"
        case groupID = "GroupId"
        case groupName = "GroupName"
        case latitude = "Latitude"
        case location = "Location"
        case longitude = "Longitude"
        case postponed = "Postponed"
        case state = "State"
        case virtualEvent = "VirtualEvent"
    }
}

enum DistanceCategories: String, Codable {
    case non = " non"
    case nonUltra = " non ultra"
    case ultra = " ultra"
}

// MARK: - EventImage
struct EventImage: Codable {
    let imageID: String
    let imageLabel: String?

    enum CodingKeys: String, CodingKey {
        case imageID = "ImageId"
        case imageLabel = "ImageLabel"
    }
}

typealias Events = [Event]
