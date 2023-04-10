//
//  MockSecureElementPass.swift
//  PMPassHelperTests
//
//  Created by Philippe Mercier on 10/04/2023.
//

import PassKit
@testable import PMPassHelper

struct MockSecureElementPass: SecureElementPass {
    var passActivationState: PKSecureElementPass.PassActivationState
    var primaryAccountIdentifier: String
    var primaryAccountNumberSuffix: String
}
