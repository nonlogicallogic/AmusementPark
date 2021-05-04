//
//  MachineTests.swift
//  AmusementParkTests
//
//  Created by kwangmin kim on 2021/05/04.
//

import XCTest
import Combine
@testable import AmusementPark

class MachineTests: XCTestCase {
    
    private var machine: Machine!
    private var storage = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "machine-test-queue")
    
    private let machineConfigurations = [
        MachineConfiguration(name: "Bumper Car",
                             img: "bumper_cars",
                             accommodation: 10,
                             runningDuration: 5.0,
                             minimumPeopleRequired: 5,
                             waitDuration: 2.0),
        MachineConfiguration(name: "Carousel",
                             img: "carousel",
                             accommodation: 30,
                             runningDuration: 20.0,
                             minimumPeopleRequired: 7,
                             waitDuration: 3.0),
        MachineConfiguration(name: "Elephant",
                             img: "elephant",
                             accommodation: 8,
                             runningDuration: 7.0,
                             minimumPeopleRequired: 6,
                             waitDuration: 4.0),
        MachineConfiguration(name: "Roller Coaster",
                             img: "roller_coaster",
                             accommodation: 20,
                             runningDuration: 12.0,
                             minimumPeopleRequired: 10,
                             waitDuration: 2.0),
        MachineConfiguration(name: "Viking",
                             img: "viking",
                             accommodation: 15,
                             runningDuration: 12.0,
                             minimumPeopleRequired: 8,
                             waitDuration: 2.0)
    ]
    
    override func setUp() {
//        machine = Machine()
//        square = Square(queue: queue)
    }
    
    override func tearDown() {}

    func test_status_init() {
        machine = Machine(configuration: machineConfigurations[0], queue: queue)
        
        let expectation = XCTestExpectation()
        machine
            .status
            .first()
            .sink {
                print($0)
                XCTAssertEqual($0, .ready)
                expectation.fulfill()
            }
            .store(in: &storage)
        wait(for: [expectation], timeout: 1)
    }
    
    // fill in the seats if there are empty seats
    func test_seats() {
        let config = MachineConfiguration(name: "Bumper Car",
                                          img: "bumper_cars",
                                          accommodation: 10,
                                          runningDuration: 5.0,
                                          minimumPeopleRequired: 5,
                                          waitDuration: 2.0)
        machine = Machine(configuration: config, queue: queue)
        
        var res = [[Person]]()
        machine
            .peopleOnSeat
            .sink {
                res.append($0)
            }
            .store(in: &storage)
        
        let people = [Person(), Person(), Person(), Person(), Person()]
        people.forEach { (person) in
            machine.welcome(person)
        }
        
        let expectation = XCTestExpectation()
        queue.async {
            XCTAssertEqual(res.last!, people)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_seats_2() {
        let config = MachineConfiguration(name: "Bumper Car",
                                          img: "bumper_cars",
                                          accommodation: 10,
                                          runningDuration: 5.0,
                                          minimumPeopleRequired: 5,
                                          waitDuration: 2.0)
        machine = Machine(configuration: config, queue: queue)
        
        let people = [Person(), Person(), Person(), Person(), Person()]
        var res = [[Person]]()
        let expectation = XCTestExpectation()
        let inversedExpectation = XCTestExpectation()
        inversedExpectation.isInverted = true
        
        machine
            .peopleOnSeat
            .sink {
                res.append($0)
                
                if res.last!.count == people.count {
                    XCTAssertEqual(res.last!, people)
                    expectation.fulfill()
                } else if res.last!.count > people.count {
                    inversedExpectation.fulfill()
                }
            }
            .store(in: &storage)
        
        people.forEach { (person) in
            machine.welcome(person)
        }
        
        wait(for: [expectation, inversedExpectation], timeout: 1)
    }
    
    // fill in the line if there are no empty seats
    
    // if it's full, the machine has to run right away
    
    // if it does not have the minimum number of people, the machine has not to start running
    
    // if it has minimum number of people, the machine has to run
    
    // the machine has to wait for some duration before running
    // the machine has to restart the waiting time
    
    // the machine has to stop after the running duration
    
    // after finishing the run, the machine has to fill in the seats with people in line
    
    // fill in the line if the machine is running
}
