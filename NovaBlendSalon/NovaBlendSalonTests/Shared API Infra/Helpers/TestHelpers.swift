//
//  TestHelpers.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 29/01/24.
//

import Foundation

func anyValidHTTPResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

func anyHTTPURLResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

func nonHTTPURLResponse() -> URLResponse {
    return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyError() -> Error {
    return NSError(domain: "Test", code: 0)
}

func anyNSError() -> NSError {
    return NSError(domain: "Test", code: 0)
}

func anyData() -> Data {
    return Data.init(_: "any data".utf8)
}
