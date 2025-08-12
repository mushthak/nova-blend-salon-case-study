//
//  LoadFromRemoteUseCaseTestsBase.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 11/08/25.
//

import XCTest

protocol RemoteLoaderTestable {
    associatedtype Loader: RemoteLoader
    associatedtype LoaderError: Error & Equatable
    
    static var emptyListJSON: Data { get }

    static var connectivityError: LoaderError { get }
    static var invalidDataError: LoaderError { get }
    
    static func makeLoader(url: URL, client: HTTPClientSpy) -> Loader
    static func makeItemsJSON(items: [[String: Any]]) -> Data
    static func makeSampleItems() -> (json: [[String: Any]], models: [Loader.Model])
}

class LoadFromRemoteUseCaseTestsBase<Spec: RemoteLoaderTestable>: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() async throws {
        let (sut, client) = makeSUT()
        _ = try await load(using: sut)
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromURLTwice() async throws {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        _ = try await load(using: sut)
        _ = try await load(using: sut)
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() async throws {
        let error = anyError()
        let (sut, _) = makeSUT(with: .failure(error))
        
        do {
            _ = try await load(using: sut)
            XCTFail("Expected connectivity error")
        } catch {
            XCTAssertEqual(error as? Spec.LoaderError, Spec.connectivityError)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async throws {
        let samples = [199, 201, 300, 400, 500]
        let emptyListJSON = Spec.makeItemsJSON(items: [])
        
        await withThrowingTaskGroup(of: [Spec.Loader.Model].self) { group in
            for statusCode in samples {
                group.addTask {
                    let response = HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
                    let (sut, _) = self.makeSUT(with: .success((emptyListJSON, response)))
                    return try await self.load(using: sut)
                }
            }
            
            while let result = await group.nextResult() {
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error as? Spec.LoaderError, Spec.invalidDataError)
                case .success:
                    XCTFail("Expected invalid data error")
                }
            }
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200WithInvalidJSON() async throws {
        let response = anyValidHTTPResponse()
        let invalidJSON = Data("invalid json".utf8)
        let (sut, _) = makeSUT(with: .success((invalidJSON, response)))
        
        do {
            _ = try await load(using: sut)
            XCTFail("Expected invalid data error")
        } catch {
            XCTAssertEqual(error as? Spec.LoaderError, Spec.invalidDataError)
        }
    }
    
    func test_load_deliversEmptyArrayOn200WithEmptyList() async throws {
        let emptyListJSON = Spec.makeItemsJSON(items: [])
        let (sut, _) = makeSUT(with: .success((emptyListJSON, anyValidHTTPResponse())))
        
        let items: [Spec.Loader.Model] = try await load(using: sut)
        XCTAssertEqual(items, [])
    }
    
    func test_load_deliversItemsArrayOn200WithJSONList() async throws {
        let sample = Spec.makeSampleItems()
        let json = Spec.makeItemsJSON(items: sample.json)
        let (sut, _) = makeSUT(with: .success((json, anyValidHTTPResponse())))
        
        let items: [Spec.Loader.Model] = try await load(using: sut)
        XCTAssertEqual(items, sample.models)
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        url: URL = anyURL(),
        with result: Result<(Data, HTTPURLResponse), Error> = .success((Spec.emptyListJSON, anyValidHTTPResponse())),
        file: StaticString = #file, line: UInt = #line
    ) -> (sut: Spec.Loader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = Spec.makeLoader(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return (sut, client)
    }
    
    private func load(using loader: Spec.Loader) async throws -> [Spec.Loader.Model] {
        try await loader.load()
    }
}
