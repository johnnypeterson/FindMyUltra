//
//  AddressResult.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/9/23.
//

import Foundation

struct AddressResult: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
}
