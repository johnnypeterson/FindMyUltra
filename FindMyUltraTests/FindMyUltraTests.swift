//
//  FindMyUltraTests.swift
//  FindMyUltraTests
//
//  Created by Johnny Peterson on 10/5/23.
//

import XCTest
@testable import FindMyUltra

final class FindMyUltraTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRequestIncludesAnnotationQueryItems() throws {
        let viewModel = MapViewModel()
        let latitude = 37.0
        let longitude = -122.0
        viewModel.annotationItems = [AnnotationItem(latitude: latitude, longitude: longitude)]
        viewModel.searchRadius = .twoHundred

        let request = viewModel.request()
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            XCTFail("Missing url or query items")
            return
        }

        let queryDictionary = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })

        XCTAssertEqual(queryDictionary["lat"], String(describing: latitude))
        XCTAssertEqual(queryDictionary["lng"], String(describing: longitude))
        XCTAssertEqual(queryDictionary["mi"], viewModel.searchRadius.network)
    }

}
