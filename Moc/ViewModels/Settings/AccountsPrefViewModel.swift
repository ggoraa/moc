//
//  AccountsPrefViewModel.swift
//  Moc
//
//  Created by Егор Яковенко on 20.01.2022.
//

import Foundation
import Backend
import TDLibKit
import Resolver
import Utilities
import Logs

class AccountsPrefViewModel: ObservableObject {
    var logger = Logs.Logger(category: "Preferences", label: "AccountPaneUI")
    @Injected var service: AccountsPrefService
    
    @Published var firstName: String = "" {
        didSet {
            if firstName.count > 64 {
                firstName = String(firstName.prefix(64))
                SystemUtils.playAlertSound()
            }
        }
    }
    @Published var lastName: String = "" {
        didSet {
            if lastName.count > 64 {
                lastName = String(lastName.prefix(64))
                SystemUtils.playAlertSound()
            }
        }
    }
    
    var updateStream: AsyncStream<Update> { service.updateStream }
    
    func updateNames() {
        Task {
            do {
                try await service.set(
                    firstName: firstName,
                    lastName: lastName)
            } catch let error {
                logger.error(error.localizedDescription)
            }
        }
    }
}
