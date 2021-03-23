//
//  MoviefyTests.swift
//  MoviefyTests
//
//  Created by Vladimir Yanakiev on 8.02.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import XCTest
import Darwin
@testable import Moviefy

class MoviefyTests: XCTestCase {
    
    var movieStoreSUT: MovieStore!
    var atomicIntegerSUT: AtomicInteger!

    override func setUp() {
        super.setUp()
        movieStoreSUT = MovieStore()
        atomicIntegerSUT = AtomicInteger()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        movieStoreSUT = nil
        atomicIntegerSUT = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConcurrencyInAtomicInteger() {
        atomicIntegerSUT.set(0)
        let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
        let forkPtr = dlsym(RTLD_DEFAULT, "fork")
        typealias ForkType = @convention(c) () -> Int32
        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
        
        // https://www.evanjones.ca/fork-is-dangerous.html
        // I also like to live dangeously.
        switch fork() {
        case 0: //Child
            for _ in 0...10000 {
                atomicIntegerSUT.increment()
            }
            XCTAssertEqual(atomicIntegerSUT.get(), 10001)
            break;
        case 1: //Parent
            for _ in 0...10000 {
                atomicIntegerSUT.increment()
            }
            XCTAssertEqual(atomicIntegerSUT.get(), 10001)
            break;
        default:
            break;
        }
    }
    
    func testLoadURL() {
        let promise = expectation(description: "Status code: 200")
        movieStoreSUT.loadURL(url: URL(string: "https://httpbin.org/get")!) { (data, response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                }
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testPerformanceInitialURL() {
        self.measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true, for: {
            self.movieStoreSUT.getMovies(from: MovieListEndpoint.popular, completion: { response in
                self.stopMeasuring()
                // Cannot measure metrics while already measuring metrics?
            })
        })
    }
}
