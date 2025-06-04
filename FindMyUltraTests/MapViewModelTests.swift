import XCTest
@testable import FindMyUltra

final class MapViewModelTests: XCTestCase {
    func testFetchAddsThreeItems() {
        let viewModel = MapViewModel()
        viewModel.fetch()
        XCTAssertEqual(viewModel.data.count, 3)
    }

    func testRequestContainsLatitudeLongitude() {
        let viewModel = MapViewModel()
        viewModel.annotationItems = [AnnotationItem(latitude: 1.0, longitude: 2.0)]
        let request = viewModel.request()
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        func value(for name: String) -> String? {
            return queryItems.first(where: { $0.name == name })?.value
        }
        XCTAssertEqual(value(for: "lat"), "1.0")
        XCTAssertEqual(value(for: "lng"), "2.0")
        XCTAssertEqual(value(for: "mi"), viewModel.distanceFromMe.network)
        XCTAssertEqual(value(for: "mo"), "12")
        XCTAssertEqual(value(for: "open"), "1")
        XCTAssertEqual(value(for: "past"), "0")
    }
}
