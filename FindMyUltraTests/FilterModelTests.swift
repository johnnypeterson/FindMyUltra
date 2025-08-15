import XCTest
@testable import FindMyUltra

final class FilterModelTests: XCTestCase {
    func testRaceDistanceNetworkValues() {
        XCTAssertEqual(RaceDistance.showAll.network, "0")
        XCTAssertEqual(RaceDistance.lessThanTen.network, "1")
        XCTAssertEqual(RaceDistance.tenToTwentySix.network, "2")
        XCTAssertEqual(RaceDistance.twentySixToForty.network, "3")
        XCTAssertEqual(RaceDistance.fortyOneToSixty.network, "4")
        XCTAssertEqual(RaceDistance.sixtyOneToNinety.network, "5")
        XCTAssertEqual(RaceDistance.ninetyToOneHundred.network, "6")
        XCTAssertEqual(RaceDistance.oneHundredPlus.network, "7")
    }

    func testSearchRadiusNetworkValues() {
        XCTAssertEqual(SearchRadius.twentyFive.network, "25")
        XCTAssertEqual(SearchRadius.fiftyMiles.network, "50")
        XCTAssertEqual(SearchRadius.oneHundred.network, "100")
        XCTAssertEqual(SearchRadius.twoHundred.network, "200")
        XCTAssertEqual(SearchRadius.threeHundred.network, "300")
        XCTAssertEqual(SearchRadius.fourHundred.network, "400")
        XCTAssertEqual(SearchRadius.fiveHundred.network, "500")
    }
}
