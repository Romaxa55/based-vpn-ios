//
//  DeviceClient.swift
//  BasedVPN
//
//  Created by Lika Vorobeva on 21.07.2023.
//

import Foundation
import ComposableArchitecture

struct DeviceClient {
    var storeTokenIfNeeded: () async throws -> Void
    var verifyDevice: () async throws -> Bool
}

private enum DeviceClientKey: DependencyKey {
    static var liveValue = DeviceClient.live
}

extension DependencyValues {
    var deviceClient: DeviceClient {
        get { self[DeviceClientKey.self] }
        set { self[DeviceClientKey.self] = newValue }
    }
}

extension DeviceClient {
    static var service = DefaultDeviceAPIService()
    static var live: Self {
        .init(
            storeTokenIfNeeded: {
                do {
                    guard APIStorage.shared.deviceToken == nil else { return }
                    let token = try await service.registerDevice(platform: "IOS")
                    APIStorage.shared.deviceToken = token
                } catch {
                    log.error(error)
                    throw error
                }
            },
            verifyDevice: {
                let response = try await service.verifyDevice()
                guard !response.isBanned else { throw ConnectionError.banned }
                return response.isEnrolled
            }
        )
    }
}
