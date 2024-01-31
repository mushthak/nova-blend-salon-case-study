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
    
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }
    private struct Stub {
        let error: Error?
        let data: Data?
    }
    
    static func stub(error: Error?, data: Data?) {
        stub = Stub(error: error, data: data)
    }
    
    static func removeStub() {
        urlRequest = nil
        stub = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {        
        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .notAllowed)
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
        
        URLProtocolStub.urlRequest = request
    }
    
    override func stopLoading() {}
    
}

