//
//  MockData.swift
//  EntrustDemoTests
//
//  Created by Philippe Mercier on 10/04/2023.
//

@testable import PMPassHelper

struct MockPassHelperData {
    static let activatedPass3333 = MockPass(mockSecureElementPass: MockSecureElementPass(
        passActivationState: .activated,
        primaryAccountIdentifier: "",
        primaryAccountNumberSuffix: "3333"
    ))

    static let deactivatedPass3333 = MockPass(mockSecureElementPass: MockSecureElementPass(
        passActivationState: .deactivated,
        primaryAccountIdentifier: "",
        primaryAccountNumberSuffix: "3333"
    ))
}
