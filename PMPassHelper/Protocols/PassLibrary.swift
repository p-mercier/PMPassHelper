//
//  PassLibrary.swift
//  EntrustDemo
//
//  Created by Philippe Mercier on 08/04/2023.
//

import PassKit

protocol PassLibrary {
    func passes() -> [Pass]
    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool
}

extension PKPassLibrary: PassLibrary {
    func passes() -> [Pass] {
        let passes: [PKPass] = passes(of: PKPassType.secureElement)
        return passes
    }
}
