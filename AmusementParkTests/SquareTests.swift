//
//  SquareTests.swift
//  AmusementParkTests
//
//  Created by kwangmin kim on 2021/05/03.
//

import XCTest
import Foundation
import Combine
@testable import AmusementPark

class SquareTests: XCTestCase {

    private var square: Square!
    private var storage = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "squre-test-queue")
    
    override func setUp() {
        square = Square()
//        square = Square(queue: queue)
    }
    
    override func tearDown() {}

    func test_welcome() {
        var res = [[Person]]()
        let expectation = XCTestExpectation()
        let count = 100

        square
            .people
            .sink {
                res.append($0)
            }
            .store(in: &storage)

        // When
        // Some people get in the square
        (0..<count).forEach { _ in
            square.welcome(Person())
        }

        queue.async {
            // Then
            // 100 people in the square
            XCTAssertEqual(res.last!.count, count)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_farewell() {
        // Given
        // 100 people at first
        let numberOfPeopleInSquare = 100

        (0..<numberOfPeopleInSquare).forEach { _ in
            self.square.welcome(Person())
        }

        var stream = [[Person]]()
        square
            .people
            .sink {
                stream.append($0)
            }
            .store(in: &storage)

        var peopleInSquare = [Person]()
        let expectation1 = XCTestExpectation()
        queue.async {
            peopleInSquare = stream.last!
            XCTAssertEqual(peopleInSquare.count, numberOfPeopleInSquare)
            expectation1.fulfill()
        }


        // When
        // some people get out the squre
        let numberOfPeopleGettingOut = 20
        let expectation2 = XCTestExpectation()
        queue.async {
            (0..<numberOfPeopleGettingOut).forEach { _ in
                print(peopleInSquare.count)
                if let person = peopleInSquare.randomElement() {
                    self.square.farewell(person)
                    if let found = peopleInSquare.firstIndex(of: person) {
                        peopleInSquare.remove(at: found)
                    }
                }
            }

            var res = [[Person]]()
            self.square
                .people
                .sink {
                    res.append($0)
                }
                .store(in: &self.storage)

            self.queue.async {
                XCTAssertEqual(peopleInSquare.count, numberOfPeopleInSquare - numberOfPeopleGettingOut)
                XCTAssertEqual(res.last!.count, peopleInSquare.count)
                expectation2.fulfill()
            }
        }

        wait(for: [expectation1, expectation2], timeout: 5)
    }

    
//    func test_welcome() {
//        var res = [[Person]]()
//        let expectation = XCTestExpectation()
//        let count = 100
//
//        square
//            .people
//            .sink {
//                res.append($0)
//            }
//            .store(in: &storage)
//
//        // When
//        // Some people get in the square
//        (0..<count).forEach { _ in
//            square.welcome(Person())
//        }
//
//        // Then
//        // 100 people in the square
//        XCTAssertEqual(res.last!.count, count)
//        expectation.fulfill()
//
//        wait(for: [expectation], timeout: 1)
//    }
//
//    func test_farewell() {
//        // Given
//        // 100 people at first
//        let numberOfPeopleInSquare = 100
//
//        (0..<numberOfPeopleInSquare).forEach { _ in
//            self.square.welcome(Person())
//        }
//
//        var stream = [[Person]]()
//        square
//            .people
//            .sink {
//                stream.append($0)
//            }
//            .store(in: &storage)
//
//        var peopleInSquare = [Person]()
//        peopleInSquare = stream.last!
//        XCTAssertEqual(peopleInSquare.count, numberOfPeopleInSquare)
//
//        // When
//        // some people get out the squre
//        let numberOfPeopleGettingOut = 20
//        (0..<numberOfPeopleGettingOut).forEach { _ in
//            print(peopleInSquare.count)
//            if let person = peopleInSquare.randomElement() {
//                self.square.farewell(person)
//                if let found = peopleInSquare.firstIndex(of: person) {
//                    peopleInSquare.remove(at: found)
//                }
//            }
//        }
//
//        var res = [[Person]]()
//        self.square
//            .people
//            .sink {
//                res.append($0)
//            }
//            .store(in: &self.storage)
//
//        XCTAssertEqual(peopleInSquare.count, numberOfPeopleInSquare - numberOfPeopleGettingOut)
//        XCTAssertEqual(res.last!.count, peopleInSquare.count)
//    }

}
