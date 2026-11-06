import XCTest
@testable import Hop

final class HopTests: XCTestCase {
    func testInitialMessageExplainsSetupState() {
        XCTAssertEqual(ContentView.initialMessage, "Pronto per configurare la prima macchina")
    }
}
