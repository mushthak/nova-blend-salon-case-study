//
//  NovaBlendSalonTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 20/01/24.
//

import XCTest

class RemoteSalonLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteSalonLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL() {
        let client = HTTPClient()
        let _ = RemoteSalonLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
