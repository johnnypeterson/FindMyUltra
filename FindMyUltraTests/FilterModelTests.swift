import XCTest
@testable import FindMyUltra

final class FilterModelTests: XCTestCase {
    func testRaceDistanceNetworkValues() {
        XCTAssertEqual(RaceDistance.showAll.network, "0")
        XCTAssertEqual(RaceDistance.lessThenTen.network, "1")
        XCTAssertEqual(RaceDistance.tenToTwentySix.network, "2")
        XCTAssertEqual(RaceDistance.twentySixtoForty.network, "3")
        XCTAssertEqual(RaceDistance.fortyOneToSixty.network, "4")
        XCTAssertEqual(RaceDistance.sixyOneToNintey.network, "5")
        XCTAssertEqual(RaceDistance.NinteyToOneHundred.network, "6")
        XCTAssertEqual(RaceDistance.oneHundredPlus.network, "7")
    }

    func testDistanceFromMeNetworkValues() {
        XCTAssertEqual(DistanceFromMe.twentyFive.network, "25")
        XCTAssertEqual(DistanceFromMe.fiftyMiles.network, "50")
        XCTAssertEqual(DistanceFromMe.oneHundred.network, "100")
        XCTAssertEqual(DistanceFromMe.twoHundred.network, "200")
        XCTAssertEqual(DistanceFromMe.threeHundred.network, "300")
        XCTAssertEqual(DistanceFromMe.fourHundred.network, "400")
        XCTAssertEqual(DistanceFromMe.fiveHundred.network, "500")
    }
}
