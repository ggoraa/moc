//
//  MocApp.swift
//  Moc
//
//  Created by Егор Яковенко on 24.12.2021.
//

import SwiftUI
import TDLibKit
import Resolver

extension Resolver {
    public static func registerViewModels() {
        register { MainViewModel() }
    }

    public static func registerTd() {
        let tdApi = TdApi(client: TdClientImpl())
        tdApi.client.run {
            do {
                let update = try tdApi.decoder.decode(Update.self, from: $0)
                switch update {
                        // MARK: - Authorization state
                    case .updateAuthorizationState(let state):
                        switch state.authorizationState {
                            case .authorizationStateWaitTdlibParameters:
                                self.post(notification: .authorizationStateWaitTdlibParameters)
                                Task {
                                    let _ = try! await tdApi.setTdlibParameters(parameters: TdlibParameters(
                                        apiHash: Bundle.main.infoDictionary?["TdApiHash"] as! String,
                                        apiId: Bundle.main.infoDictionary?["TdApiId"] as! Int,
                                        applicationVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
                                        databaseDirectory: "",
                                        deviceModel: self.getMacModel() ?? "Unknown",
                                        enableStorageOptimizer: true,
                                        filesDirectory: "",
                                        ignoreFileNames: false,
                                        systemLanguageCode: "en-US",
                                        systemVersion: getOSVersionString(),
                                        useChatInfoDatabase: true,
                                        useFileDatabase: true,
                                        useMessageDatabase: true,
                                        useSecretChats: false,
                                        useTestDc: false
                                    ))
                                }
                            case .authorizationStateWaitEncryptionKey(_):
                                self.post(notification: .authorizationStateWaitEncryptionKey)
                                Task(priority: .medium) {
                                    try! await tdApi.checkDatabaseEncryptionKey(encryptionKey: nil)
                                }
                            case .authorizationStateWaitPhoneNumber:
                                self.post(notification: .authorizationStateWaitPhoneNumber)
                            case .authorizationStateWaitCode(let info):
                                self.post(notification: .authorizationStateWaitCode, withObject: info)
                            case .authorizationStateWaitRegistration(let info):
                                self.post(notification: .authorizationStateWaitRegistration, withObject: info)
                            case .authorizationStateWaitPassword(let info):
                                self.post(notification: .authorizationStateWaitPassword, withObject: info)
                            case .authorizationStateReady:
                                self.post(notification: .authorizationStateReady)
                            case .authorizationStateWaitOtherDeviceConfirmation(let info):
                                self.post(notification: .authorizationStateWaitOtherDeviceConfirmation, withObject: info)
                            case .authorizationStateLoggingOut:
                                self.post(notification: .authorizationStateLoggingOut)
                            case .authorizationStateClosing:
                                self.post(notification: .authorizationStateClosing)
                            case .authorizationStateClosed:
                                self.post(notification: .authorizationStateClosed)
                        }
                        // MARK: - Chat position
                    case .updateChatPosition(let state):
                        self.post(notification: .updateChatPosition, withObject: state)
                    default:
                        NSLog("Unhandled TDLib update \(update)")
                }
            } catch {
                NSLog("Error in TDLib update handler \(error.localizedDescription)")
            }
        }
        register { tdApi }
    }

    static func post(notification: NSNotification.Name) {
        NotificationCenter.default.post(name: notification, object: nil)
    }

    static func post(notification: NSNotification.Name, withObject obj: Any?) {
        NotificationCenter.default.post(name: notification, object: obj)
    }

    // Thanks to https://www.reddit.com/r/swift/comments/gwf9fa/how_do_i_find_the_model_of_the_mac_in_swift/
    static func getMacModel() -> String? {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        var modelIdentifier: String?

        if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
            if let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(using: .utf8) {
                modelIdentifier = String(cString: modelIdentifierCString)
            }
        }

        IOObjectRelease(service)
        return modelIdentifier
    }

    static func getOSVersionString() -> String {
        let info = ProcessInfo().operatingSystemVersionString
        var systemVersionCodename: String {
            let version = ProcessInfo().operatingSystemVersion.majorVersion
            switch version {
                case 11:
                    return "macOS 11 Big Sur"
                case 12:
                    return "macOS 12 Monterey"
                default:
                    return "macOS \(version)"
            }
        }

        return "\(systemVersionCodename) \(info)"
    }
}

@main
struct MocApp: App {

    init() {
        Resolver.registerViewModels()
        Resolver.registerTd()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
