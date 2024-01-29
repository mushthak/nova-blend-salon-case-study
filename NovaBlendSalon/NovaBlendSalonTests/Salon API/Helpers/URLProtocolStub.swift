//
//  URLProtocolStub.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 28/01/24.
//

import Foundation

class URLProtocolStub: URLProtocol {
    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
    
    private static var _urlRequest: URLRequest?
    static var urlRequest: URLRequest? {
        get { return queue.sync { _urlRequest } }
        set { queue.sync { _urlRequest = newValue } }
    }
    
    private static var _error: Error?
    static var error: Error? {
        get { return queue.sync { _error } }
        set { queue.sync { _error = newValue } }
    }
    
    static func removeStub() {
        urlRequest = nil
        error = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .allowed)
        
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }

        URLProtocolStub.urlRequest = request
    }
    
    override func stopLoading() {}
    
}

