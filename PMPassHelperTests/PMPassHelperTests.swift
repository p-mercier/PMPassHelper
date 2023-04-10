//
//  PMPassHelperTests.swift
//  PMPassHelperTests
//
//  Created by Philippe Mercier on 10/04/2023.
//

import XCTest
@testable import PMPassHelper

class PMPassHelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_lastDigitsListEmpty() {
        let mockPassLibrary = MockPassLibrary(mockPasses: [], canAddSecureElementPass: false)
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: [], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, false)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }

    func test_lastDigitsListNotEmpty_existingPassesEmpty() {
        let mockPassLibrary = MockPassLibrary(mockPasses: [], canAddSecureElementPass: false)
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, true)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }

    // MARK: Single lastDigits tests

    // Matching activated pass

    func test_MatchingActivatedPass_CannotAppleWatch() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.activatedPass3333
            ],
            canAddSecureElementPass: false
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, false)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }
    
    func test_MatchingActivatedPass_CanAppleWatch() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.activatedPass3333
            ],
            canAddSecureElementPass: true
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, false)
        XCTAssertEqual(result.remotePassEntriesAvailable, true)
    }
    
    // Matching deactivated pass

    func test_MatchingDeactivatedPass() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.deactivatedPass3333
            ],
            canAddSecureElementPass: false
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, false)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }

    // No matching pass

    func test_NoMatchingPass() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.activatedPass3333
            ],
            canAddSecureElementPass: false
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["4444"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, true)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }

    // MARK: Multiple lastDigits tests

    func test_MultipleLastDigits_withoutMatch_withMatchActivatedCanAppleWatch() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.activatedPass3333
            ],
            canAddSecureElementPass: true
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["4444", "3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, true)
        XCTAssertEqual(result.remotePassEntriesAvailable, true)
    }

    func test_MultipleLastDigits_withoutMatch_withMatchActivatedCannotAppleWatch() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.activatedPass3333
            ],
            canAddSecureElementPass: false
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["4444", "3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, true)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }

    func test_MultipleLastDigits_withoutMatch_withMatchDeactivated() {
        let mockPassLibrary = MockPassLibrary(
            mockPasses: [
                MockPassHelperData.deactivatedPass3333
            ],
            canAddSecureElementPass: true
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let result = passHelper.status(lastDigitsList: ["4444", "3333"], requiresAuthentication: false)

        XCTAssertEqual(result.passEntriesAvailable, true)
        XCTAssertEqual(result.remotePassEntriesAvailable, false)
    }

    // MARK: Performance

    func testPerformance() {
        var longLastDigitsList: [String] = []
        var longMockPassesList: [MockPass] = []

        for _ in 1...100 {
            // lastDigits
            let randomNum = Int.random(in: 0...9999)
            let numString = String(format: "%04d", randomNum)

            longLastDigitsList.append(numString)
            
            // passes
            let randomNum2 = Int.random(in: 0...9999)
            let numString2 = String(format: "%04d", randomNum2)

            longMockPassesList.append(
                MockPass(mockSecureElementPass: MockSecureElementPass(
                    passActivationState: .activated,
                    primaryAccountIdentifier: "",
                    primaryAccountNumberSuffix: numString2
                ))
            )
        }

        let mockPassLibrary = MockPassLibrary(
            mockPasses: longMockPassesList,
            canAddSecureElementPass: true
        )
        let passHelper = PassHelper(passLibrary: mockPassLibrary)

        let expectation = self.expectation(description: "Performance")
        DispatchQueue.main.async {
            let _ = passHelper.status(lastDigitsList: longLastDigitsList, requiresAuthentication: false)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }

}
