import XCTest
@testable import FindMyUltra

final class ApiErrorTests: XCTestCase {
    func testCustomDescription() {
        XCTAssertEqual(ApiError.requestFailed(description: "bad").customDescription, "Request Failed: bad")
        XCTAssertEqual(ApiError.invalidData.customDescription, "Invalid Data)")
        XCTAssertEqual(ApiError.invalidUrl.customDescription, "Invalid Url")
        XCTAssertEqual(ApiError.responseUnsuccessful(description: "404").customDescription, "Unsuccessful: 404")
        XCTAssertEqual(ApiError.jsonConversionFailure(description: "bad json").customDescription, "JSON Conversion Failure: bad json")
        XCTAssertEqual(ApiError.jsonParsingFailure.customDescription, "JSON Parsing Failure")
        XCTAssertEqual(ApiError.failedSerialization.customDescription, "Serialization failed.")
        XCTAssertEqual(ApiError.noInternet.customDescription, "No internet connection")
    }
}
