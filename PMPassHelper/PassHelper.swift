//
//  PassHelper.swift
//  EntrustDemo
//
//  Created by Philippe Mercier on 08/04/2023.
//

import PassKit

public struct PassHelper {
    private let passLibrary: PassLibrary

    init(passLibrary: PassLibrary = PKPassLibrary()) {
        self.passLibrary = passLibrary
    }

    func status(
        lastDigitsList: [String],
        requiresAuthentication: Bool
    ) -> PKIssuerProvisioningExtensionStatus {
        let status = PKIssuerProvisioningExtensionStatus()
        status.requiresAuthentication = requiresAuthentication

        if lastDigitsList.isEmpty == false {
            // get existing passes
            let existingPasses: [Pass] = passLibrary.passes()

            if existingPasses.isEmpty == false {
                // create a dictionnary for quick access of secure elements by using their numberSuffix
                var secureElementPassesDict: [String: SecureElementPass] = [:]
                for existingPass in existingPasses {
                    if let secureElementPass = existingPass.getSecureElementPass() {
                        secureElementPassesDict[secureElementPass.primaryAccountNumberSuffix] = secureElementPass
                    }
                }

                // check cards status
                for lastDigits in lastDigitsList {
                    if let secureElementPass = secureElementPassesDict[lastDigits] {
                        if secureElementPass.passActivationState != .deactivated {
                            // payment card is not available to add to an iPhone but still need to check for apple watch
                            let canAddSecureElementPass = passLibrary.canAddSecureElementPass(primaryAccountIdentifier: secureElementPass.primaryAccountIdentifier)
                            if canAddSecureElementPass {
                                // payment card is available to add to an Apple Watch.
                                status.remotePassEntriesAvailable = true
                                
                                // if remotePassEntriesAvailable and passEntriesAvailable are true no need to check more cards
                                if status.passEntriesAvailable == true {
                                    return status
                                }
                            }
                        }
                    } else {
                        // payment card is available to add to an iPhone.
                        status.passEntriesAvailable = true

                        // if passEntriesAvailable and remotePassEntriesAvailable are true no need to check more cards
                        if status.remotePassEntriesAvailable == true {
                            return status
                        }
                    }
                }
            } else {
                // no existing passes so it is possible to add any new pass
                status.passEntriesAvailable = true
                return status
            }
        }
        return status
    }
}
