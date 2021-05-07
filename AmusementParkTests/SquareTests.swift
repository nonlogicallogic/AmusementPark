//
//  SquareTests.swift
//  AmusementParkTests
//
//  Created by kwangmin kim on 2021/05/04.
//

import XCTest
import Combine
@testable import AmusementPark

class SquareTests: XCTestCase {
    
    var square: Square!
    
    private let queue = DispatchQueue(label: "squre-test-queue")
    private var storage = Set<AnyCancellable>()
    
    override func setUp() {
        square = Square(queue: queue)
    }
    
    func test_welcome() {
        var res = [[Person]]()
        square
            .people
            .sink {
                res.append($0)
            }
            .store(in: &storage)
        
        // When
        // person comes to the square
        let person = Person()
        square.welcome(person)
        
        // Then
        // the people property emitts the new comers
        let exp = [
            [],
            [person]
        ]
        
        let expection = XCTestExpectation()
        queue.async {
            XCTAssertEqual(res, exp)
            expection.fulfill()
        }
        
        wait(for: [expection], timeout: 2)
    }
    
    func test_welcome_2() {
        let person = Person()
        let expection = XCTestExpectation()
        let inversedExpection = XCTestExpectation()
        inversedExpection.isInverted = true
        let exp = [
            [],
            [person]
        ]
        
        square
            .people
            .collect(2)
            .sink {
                XCTAssertEqual($0, exp)
                expection.fulfill()
            }
            .store(in: &storage)
        
        square
            .people
            .collect(3)
            .sink { _ in
                inversedExpection.fulfill()
            }
            .store(in: &storage)
        
        // When
        // person comes to the square
        square.welcome(person)
        
        // Then
        // the people property emitts the new comers
        
        wait(for: [expection, inversedExpection], timeout: 1)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func test_welcome_3() {
        let person = Person()
        
        // Then
        // the people property emitts the new comers
        let expectation = XCTestExpectation()
        let exp = [
            [],
            [person]
        ]
        square
            .people
            .collect(2)
            .sink {
                XCTAssertEqual($0, exp)
                expectation.fulfill()
            }
            .store(in: &storage)
        
        let inversedExpectation = XCTestExpectation()
        inversedExpectation.isInverted = true
        square
            .people
            .collect(3)
            .sink { _ in
                inversedExpectation.fulfill()
            }
            .store(in: &storage)
        
        // When
        // person comes to the square
        square.welcome(person)
        wait(for: [expectation, inversedExpectation], timeout: 1)
    }

}
