//
//  AmusementParkTests.swift
//  AmusementParkTests
//
//  Created by kwangmin kim on 2021/04/29.
//

import XCTest
import Combine
@testable import AmusementPark

class MockSquare: SquareType {
    
    lazy var people: AnyPublisher<[Person], Never> = { _people.eraseToAnyPublisher() }()
    
    var _people = CurrentValueSubject<[Person], Never>([])
    
    func welcome(_ person: Person) {
        _people.send([person])
    }
    
    func farewell(_ person: Person) {
    }
}


class MockMachine: MachineType {
    
    lazy var status: AnyPublisher<Machine.Status, Never> = { _status.eraseToAnyPublisher() }()
    
    lazy var peopleOnSeat: AnyPublisher<[Person], Never> = { _peopleOnSeat.eraseToAnyPublisher() }()
    
    lazy var peopleInLine: AnyPublisher<[Person], Never> = { _peopleInLine.eraseToAnyPublisher() }()
    
    lazy var peopleExiting: AnyPublisher<[Person], Never> = { _peopleExiting.eraseToAnyPublisher() }()
    
    lazy var remainingTime: AnyPublisher<Int?, Never> = { _remainingTime.eraseToAnyPublisher() }()
    
    private(set) var configuration: MachineConfiguration = MachineConfiguration(name: "Bumper Car",
                                                                                img: "bumper_cars",
                                                                                accommodation: 10,
                                                                                runningDuration: 5.0,
                                                                                minimumPeopleRequired: 5,
                                                                                waitDuration: 2.0)
    
    var _remainingTime = CurrentValueSubject<Int?, Never>(nil)
    
    var _status = CurrentValueSubject<Machine.Status, Never>(.ready)
    
    var _peopleOnSeat = CurrentValueSubject<[Person], Never>([])
    
    var _peopleInLine = CurrentValueSubject<[Person], Never>([])
    
    var _peopleExiting = PassthroughSubject<[Person], Never>()
    
    func welcome(_ person: Person) {
    }
    
    func farewell(_ person: Person) {
    }
    
    
}


class AmusementParkTests: XCTestCase {
    
    var park: AmusementPark!
    var mockSquare: MockSquare!
    var mockMachine: MockMachine!
    
    private var storage = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "park-test-queue")
    
    override func setUp() {
        mockSquare = MockSquare()
        mockMachine = MockMachine()
        let config = AmusementParkConfiguration(accommodation: 10,
                                                machineConfigurations: [mockMachine.configuration])
        park = AmusementPark(square: mockSquare,
                             machines: [mockMachine],
                             configuration: config,
                             queue: queue)
    }
    
    func test_people_from_machine_to_square() {
        var res = [[Person]]()
        park.square
            .people
            .sink {
                res.append($0)
            }
            .store(in: &storage)
        
        let person = Person()
        mockMachine._peopleExiting.send([person])
        
        let expectation = XCTestExpectation()
        queue.async {
            XCTAssertEqual(res.last!, [person])
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
}
