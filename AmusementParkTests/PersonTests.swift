//
//  PersonTests.swift
//  AmusementParkTests
//
//  Created by kwangmin kim on 2021/05/04.
//

import XCTest
@testable import AmusementPark

class PersonTests: XCTestCase {
    
    class MockPlace: Place {
        var welcomCount = 0
        var farewellCount = 0
        
        func welcome(_ person: Person) {
            welcomCount += 1
        }
        
        func farewell(_ person: Person) {
            farewellCount += 1
        }
        
        
    }
    
    var person: Person!
    
    override func setUp() {}
    
    override func tearDown() {}

    func test_enter() {
        let person = Person()
        let mockPlace = MockPlace()
        
        person.enter(mockPlace)
        person.enter(mockPlace)
        person.enter(mockPlace)
        person.enter(mockPlace)
        XCTAssertEqual(mockPlace.welcomCount, 4)
    }
    
    func test_exit() {
        let person = Person()
        let mockPlace = MockPlace()
        
        person.exit(mockPlace)
        person.exit(mockPlace)
        person.exit(mockPlace)
        person.exit(mockPlace)
        XCTAssertEqual(mockPlace.farewellCount, 4)
    }
    
    func test_equtable() {
        let person1 = Person()
        let person2 = Person()
        XCTAssertNotEqual(person1, person2)
    }
}
