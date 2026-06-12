//
//  DependencyContainerTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheMovies

struct DependencyContainerTests {

    @Test
    func makeDefault_resolvesAPIClient() {
        let container = DependencyContainer.makeDefault()

        #expect(container.apiClient is APIClient)
    }

    @Test
    func init_usesInjectedAPIClient() {
        let mockClient = MockAPIClient()
        let container = DependencyContainer(apiClient: mockClient)

        #expect(container.apiClient as? MockAPIClient === mockClient)
    }
}
