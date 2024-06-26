//
//  AddressResult.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 4/8/24.
//


import Foundation

struct AddressResult: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
}
