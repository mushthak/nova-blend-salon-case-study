//
//  XCTestCase+MemoryLeakTracking.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 29/01/24.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
