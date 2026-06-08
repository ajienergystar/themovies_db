//
//  AsyncTestHelpers.swift
//  TheMoviesTests
//

import Foundation

enum AsyncTestHelpers {

    @discardableResult
    static func waitUntil(
        timeout: Duration = .seconds(2),
        pollInterval: Duration = .milliseconds(10),
        condition: @escaping () -> Bool
    ) async -> Bool {
        let deadline = ContinuousClock.now + timeout
        while !condition() {
            if ContinuousClock.now >= deadline {
                return false
            }
            await Task.yield()
            try? await Task.sleep(for: pollInterval)
        }
        return true
    }
}
