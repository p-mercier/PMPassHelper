//
//  MockPassLibrary.swift
//  PMPassHelperTests
//
//  Created by Philippe Mercier on 10/04/2023.
//

@testable import PMPassHelper

struct MockPassLibrary: PassLibrary {
    let mockPasses: [MockPass]
    let canAddSecureElementPass: Bool

    func passes() -> [Pass] {
        return mockPasses
    }

    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool {
        return canAddSecureElementPass
    }
}
