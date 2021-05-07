//
//  Simulator.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/05/03.
//

import Foundation
import Combine

final class Simulator {
    let park: AmusementPark
    
    private let configuration: SimulatorConfiguration
    private let serialQueue: DispatchQueue
    private var storage = Set<AnyCancellable>()
    
    private var peopleComingSubscription: AnyCancellable?
    
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
    
    init(configuration: SimulatorConfiguration, queue: DispatchQueue? = nil) {
        self.configuration = configuration
        
        if let queue = queue {
            self.serialQueue = queue
        } else {
            self.serialQueue = DispatchQueue(label: "simulator-queue")
        }
        
        // square
        let square = Square()
        
        // machines
        let numberOfMachines = max(min(configuration.numberOfMachines, 5), 0)
        let machineConfigs = [MachineConfiguration](self.machineConfigurations[0..<numberOfMachines])
        let machines = machineConfigs.map { Machine(configuration: $0) }
        
        // config
        let parkConfiguration = AmusementParkConfiguration(accommodation: configuration.accommodation,
                                                           machineConfigurations: machineConfigs)
        park = AmusementPark(square: square, machines: machines, configuration: parkConfiguration)
    }
    
    func simulatePeopleComing() {
        peopleComingSubscription = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
            .receive(on: serialQueue)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.getPeopleIntoTheSquare()
            }
    }
    
    func getPeopleIntoTheSquare() {
        guard park.accommodated < park.configuration.accommodation else {
            peopleComingSubscription?.cancel()
            peopleComingSubscription = nil
            return
        }
        Person().enter(park.square)
        park.accommodated += 1
    }
    
    func simulatePeopleGettingIntoMachines() {
        Timer.publish(every: 2, on: .current, in: .common).autoconnect()
            .combineLatest(park.square.people)
            .removeDuplicates { $0.0 == $1.0 }
            .map { $0.1 }
            .receive(on: serialQueue)
            .sink { [weak self] people in
                guard let self = self else { return }
                self.getPeopleIntoMachinesRandomly(people: people)
            }
            .store(in: &storage)

    }
    
    func getPeopleIntoMachinesRandomly(people: [Person]) {
        var people = people
        let uppperBound = min(park.machines.count * 4, people.count)
        let count = Int.random(in: 0...uppperBound)
        (0..<count).forEach { _ in
            if let person = people.randomElement(), let machine = park.machines.randomElement() {
                person.exit(park.square)
                person.enter(machine)
                people.remove(at: people.firstIndex(of: person)!)
            }
        }
    }
}
