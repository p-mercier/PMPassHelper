//
//  Pass.swift
//  EntrustDemo
//
//  Created by Philippe Mercier on 08/04/2023.
//

import PassKit

protocol Pass {
    func getSecureElementPass() -> SecureElementPass?
}

extension PKPass: Pass {
    func getSecureElementPass() -> SecureElementPass? {
        return secureElementPass
    }
}
