//
//  Pass.swift
//  EntrustDemo
//
//  Created by Philippe Mercier on 08/04/2023.
//

import PassKit

protocol SecureElementPass {
    var passActivationState: PKSecureElementPass.PassActivationState { get }
    var primaryAccountIdentifier: String { get }
    var primaryAccountNumberSuffix: String { get }
}

extension PKSecureElementPass: SecureElementPass {
}
