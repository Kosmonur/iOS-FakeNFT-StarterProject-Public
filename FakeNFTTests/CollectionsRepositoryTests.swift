//
//  CollectionsNavigationState.swift
//  FakeNFT
//
//  Created by Александр Поляков on 08.10.2023.
//

@testable import FakeNFT
import XCTest

final class CatalogDataRepositoryTests: XCTestCase {
    var sut: CatalogDataProvider!
    var mockClient: MockNetworkClient!

    override func setUp() {
        super.setUp()
        mockClient = MockNetworkClient()
        sut = CatalogDataProvider(client: mockClient)
    }
    
    // MARK: - All collections
    func testGiveMeAllCollectionsReturnsCollections() {
        
        // Given
        let mockCollection = [
            CollectionModel(
            createdAt: "Date",
            name: "Test",
            cover: "CoverURL",
            nfts: ["1", "2"],
            description: "TestDescription",
            id: "1",
            author: "Boss")
        ]
        let data = try! JSONEncoder().encode(mockCollection)
        mockClient.mockData = data

        // When
        var resultCollection: [CollectionModel]?
        sut.fetchMeAllCollections() { result in
            switch result {
                case .success(let collections):
                resultCollection = collections
                case .failure:
                resultCollection = []
            }
        }
                
        // Then
        guard let result = resultCollection else {return}
        XCTAssertNotNil(result)
        XCTAssertEqual(result.first?.name, "Test")
    }

    override func tearDown() {
        sut = nil
        mockClient = nil
        super.tearDown()
    }
}
