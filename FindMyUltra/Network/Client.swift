//
//  File.swift
//  UltraMapper
//
//  Created by Johnny Peterson on 10/5/23.
//

import Foundation

final class Client: GenericApi, @unchecked Sendable {

    let session: URLSession

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    convenience init() {
        self.init(configuration: .default)
    }
}
