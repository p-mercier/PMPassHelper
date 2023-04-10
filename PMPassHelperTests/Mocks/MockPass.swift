//
//  MockPass.swift
//  PMPassHelperTests
//
//  Created by Philippe Mercier on 10/04/2023.
//

@testable import PMPassHelper

struct MockPass: Pass {
    let mockSecureElementPass: MockSecureElementPass

    func getSecureElementPass() -> SecureElementPass? {
        return mockSecureElementPass
    }
}
